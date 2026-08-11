import type { Api, Model } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Input, Key, matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

function providerLabel(id: string): string {
	return id
		.split("-")
		.map((part) => part.charAt(0).toUpperCase() + part.slice(1))
		.join(" ");
}

function formatContextWindow(tokens: number): string {
	if (tokens >= 1_000_000) return `${(tokens / 1_000_000).toFixed(0)}M`;
	if (tokens >= 1_000) return `${(tokens / 1_000).toFixed(0)}k`;
	return String(tokens);
}

function frameLine(width: number, left: string, fill: string, right: string): string {
	if (width <= 0) return "";
	if (width === 1) return left;
	return left + fill.repeat(Math.max(0, width - 2)) + right;
}

type PickerTheme = {
	fg: (color: string, text: string) => string;
	bold: (text: string) => string;
};

function pickerTheme(theme: any): PickerTheme {
	return {
		fg: typeof theme?.fg === "function" ? theme.fg.bind(theme) : (_color: string, text: string) => text,
		bold: typeof theme?.bold === "function" ? theme.bold.bind(theme) : (text: string) => text,
	};
}

interface ModelPickerOptions {
	allModels: Model<Api>[];
	currentModel: Model<Api> | undefined;
	onSelect: (model: Model<Api>) => void;
	onCancel: () => void;
}

class ModelPickerComponent {
	focused = false;

	private categories: string[];
	private catIndex: number;
	private rowIndex = 0;
	private byCategory: Map<string, Model<Api>[]>;
	private searchTerms: Map<string, string> = new Map();
	private searchInput: Input;
	private filteredRows: Model<Api>[] = [];

	constructor(private opts: ModelPickerOptions) {
		this.byCategory = this.buildCategories();
		this.categories = Array.from(this.byCategory.keys());

		const current = opts.currentModel;
		const startCategory = current && this.byCategory.has(current.provider) ? current.provider : this.categories[0];
		this.catIndex = Math.max(0, this.categories.indexOf(startCategory ?? ""));

		this.searchInput = new Input();
		this.searchInput.focused = true;
		this.searchInput.onEscape = () => opts.onCancel();
		this.searchInput.onSubmit = () => {
			const selected = this.filteredRows[this.rowIndex];
			if (selected) opts.onSelect(selected);
		};

		this.applyFilter();
		if (current) {
			const index = this.filteredRows.findIndex((model) => model.id === current.id && model.provider === current.provider);
			this.rowIndex = Math.max(0, index);
		}
	}

	set focusedState(value: boolean) {
		this.focused = value;
		this.searchInput.focused = value;
	}

	private buildCategories(): Map<string, Model<Api>[]> {
		const map = new Map<string, Model<Api>[]>();
		for (const model of this.opts.allModels) {
			if (!map.has(model.provider)) map.set(model.provider, []);
			map.get(model.provider)!.push(model);
		}

		const current = this.opts.currentModel;
		for (const [, models] of map) {
			models.sort((a, b) => {
				const aCurrent = current && a.id === current.id && a.provider === current.provider ? -1 : 0;
				const bCurrent = current && b.id === current.id && b.provider === current.provider ? -1 : 0;
				if (aCurrent !== bCurrent) return aCurrent - bCurrent;
				return a.name.localeCompare(b.name);
			});
		}

		return new Map(
			[...map.entries()].sort(([aKey], [bKey]) => {
				const aCurrent = current && aKey === current.provider ? -1 : 0;
				const bCurrent = current && bKey === current.provider ? -1 : 0;
				if (aCurrent !== bCurrent) return aCurrent - bCurrent;
				return aKey.localeCompare(bKey);
			}),
		);
	}

	private applyFilter(): void {
		const categoryKey = this.categories[this.catIndex] ?? "";
		const source = this.byCategory.get(categoryKey) ?? [];
		const query = (this.searchTerms.get(categoryKey) ?? "").toLowerCase().trim();

		this.filteredRows = query
			? source.filter((model) => model.name.toLowerCase().includes(query) || model.id.toLowerCase().includes(query))
			: source;
		this.rowIndex = Math.min(this.rowIndex, Math.max(0, this.filteredRows.length - 1));
	}

	private switchCategory(delta: number): void {
		if (this.categories.length === 0) return;

		const oldKey = this.categories[this.catIndex] ?? "";
		this.searchTerms.set(oldKey, this.searchInput.getValue());

		this.catIndex = (this.catIndex + delta + this.categories.length) % this.categories.length;

		const newKey = this.categories[this.catIndex] ?? "";
		this.searchInput.setValue(this.searchTerms.get(newKey) ?? "");

		this.rowIndex = 0;
		this.applyFilter();
	}

	handleInput(data: string): void {
		if (matchesKey(data, Key.up)) {
			if (this.filteredRows.length > 0) this.rowIndex = this.rowIndex === 0 ? this.filteredRows.length - 1 : this.rowIndex - 1;
			return;
		}
		if (matchesKey(data, Key.down)) {
			if (this.filteredRows.length > 0) this.rowIndex = this.rowIndex === this.filteredRows.length - 1 ? 0 : this.rowIndex + 1;
			return;
		}

		if (matchesKey(data, Key.tab)) {
			this.switchCategory(1);
			return;
		}
		if (matchesKey(data, Key.shift("tab"))) {
			this.switchCategory(-1);
			return;
		}
		if (matchesKey(data, Key.left) && this.searchInput.getValue() === "") {
			this.switchCategory(-1);
			return;
		}
		if (matchesKey(data, Key.right) && this.searchInput.getValue() === "") {
			this.switchCategory(1);
			return;
		}

		const before = this.searchInput.getValue();
		this.searchInput.handleInput(data);
		const after = this.searchInput.getValue();

		if (before !== after) {
			const categoryKey = this.categories[this.catIndex] ?? "";
			this.searchTerms.set(categoryKey, after);
			this.rowIndex = 0;
			this.applyFilter();
		}
	}

	render(width: number, theme: PickerTheme): string[] {
		const lines: string[] = [];

		lines.push(this.renderTabs(width, theme));
		lines.push(theme.fg("border", "─".repeat(width)));

		const prompt = theme.fg("muted", "  Search: ");
		const promptWidth = visibleWidth("  Search: ");
		const inputLines = this.searchInput.render(Math.max(1, width - promptWidth));
		lines.push(prompt + (inputLines[0] ?? ""));
		lines.push(theme.fg("border", "─".repeat(width)));

		const maxVisible = 10;
		const half = Math.floor(maxVisible / 2);
		const rows = this.filteredRows;
		const start = Math.max(0, Math.min(this.rowIndex - half, rows.length - maxVisible));
		const visible = rows.slice(start, start + maxVisible);

		if (rows.length === 0) {
			const query = this.searchInput.getValue();
			const message = query ? `  No models match "${query}"` : "  No models in this category";
			lines.push(theme.fg("muted", truncateToWidth(message, width)));
		} else {
			for (let i = 0; i < visible.length; i++) {
				const model = visible[i]!;
				const absoluteIndex = start + i;
				const isSelected = absoluteIndex === this.rowIndex;
				const isCurrent = this.opts.currentModel?.id === model.id && this.opts.currentModel?.provider === model.provider;
				lines.push(this.renderRow(model, isSelected, isCurrent, width, theme));
			}
			if (rows.length > maxVisible) {
				const shown = `${start + 1}–${Math.min(start + maxVisible, rows.length)} of ${rows.length}`;
				lines.push(theme.fg("dim", truncateToWidth("  " + shown, width)));
			}
		}

		lines.push(theme.fg("border", "─".repeat(width)));
		const help = "↑↓ navigate  ·  Tab/← → category  ·  enter select  ·  esc cancel";
		lines.push(theme.fg("dim", truncateToWidth("  " + help, width)));

		return lines;
	}

	private renderTabs(width: number, theme: PickerTheme): string {
		if (this.categories.length === 0) return theme.fg("muted", truncateToWidth("  No providers", width));

		const total = this.categories.length;
		const active = this.catIndex;
		const arrowWidth = 4;
		const separatorWidth = 1;
		const availableForTabs = width - arrowWidth;

		let low = active;
		let high = active;
		let used = visibleWidth(` ${providerLabel(this.categories[active]!)} `);

		while (true) {
			let expanded = false;
			if (high + 1 < total) {
				const candidateWidth = separatorWidth + visibleWidth(` ${providerLabel(this.categories[high + 1]!)} `);
				if (used + candidateWidth <= availableForTabs) {
					high++;
					used += candidateWidth;
					expanded = true;
				}
			}
			if (low - 1 >= 0) {
				const candidateWidth = separatorWidth + visibleWidth(` ${providerLabel(this.categories[low - 1]!)} `);
				if (used + candidateWidth <= availableForTabs) {
					low--;
					used += candidateWidth;
					expanded = true;
				}
			}
			if (!expanded) break;
		}

		const segments: string[] = [];
		for (let i = low; i <= high; i++) {
			const label = ` ${providerLabel(this.categories[i]!)} `;
			segments.push(i === active ? theme.fg("accent", theme.bold(label)) : theme.fg("muted", label));
		}

		const tabPart = segments.join(theme.fg("dim", "│"));
		const leftPart = low > 0 ? theme.fg("dim", "◀ ") : "  ";
		const rightPart = high < total - 1 ? theme.fg("dim", " ▶") : "  ";

		return truncateToWidth(leftPart + tabPart + rightPart, width);
	}

	private renderRow(model: Model<Api>, isSelected: boolean, isCurrent: boolean, width: number, theme: PickerTheme): string {
		const prefix = isSelected ? "▶ " : "  ";
		const contextWindow = formatContextWindow(model.contextWindow);
		const tags: string[] = [];
		if (model.reasoning) tags.push("thinking");
		if (model.input.includes("image")) tags.push("vision");
		const right = `${contextWindow}  ${tags.join(" ")}`;

		const currentMark = isCurrent ? " ●" : "";
		const nameAvailable = width - visibleWidth(prefix) - visibleWidth(right) - visibleWidth(currentMark) - 2;
		const name = truncateToWidth(model.name, Math.max(nameAvailable, 10));
		const gap = " ".repeat(Math.max(0, width - visibleWidth(prefix + name + currentMark) - visibleWidth(right)));

		if (isSelected) return theme.fg("accent", prefix + name + currentMark) + gap + theme.fg("accent", theme.bold(right));
		if (isCurrent) return theme.fg("success", prefix + name + currentMark) + gap + theme.fg("muted", right);
		return theme.fg("text", prefix + name) + gap + theme.fg("dim", right);
	}

	invalidate(): void {
		this.searchInput.invalidate();
	}
}

export default function modelPickerExtension(pi: ExtensionAPI) {
	async function openPicker(ctx: ExtensionContext) {
		await ctx.modelRegistry.refresh();
		const allModels = ctx.modelRegistry.getAvailable();

		if (allModels.length === 0) {
			ctx.ui.notify("No models available", "warning");
			return;
		}

		const selected = await ctx.ui.custom<Model<Api> | null>((tui, rawTheme, _keyboard, done) => {
			const theme = pickerTheme(rawTheme);
			const picker = new ModelPickerComponent({
				allModels,
				currentModel: ctx.model ?? undefined,
				onSelect: (model) => done(model),
				onCancel: () => done(null),
			});
			picker.focusedState = true;

			return {
				focused: true,
				render(width: number): string[] {
					return [
						theme.fg("accent", frameLine(width, "┌", "─", "┐")),
						theme.fg("accent", truncateToWidth("  Select Model", width)),
						theme.fg("accent", frameLine(width, "├", "─", "┤")),
						...picker.render(width, theme),
						theme.fg("accent", frameLine(width, "└", "─", "┘")),
					];
				},
				invalidate() {
					picker.invalidate();
				},
				handleInput(data: string) {
					picker.handleInput(data);
					tui.requestRender();
				},
			};
		});

		if (!selected) return;

		const success = await pi.setModel(selected);
		if (success) ctx.ui.notify(`Model: ${selected.name}`, "success");
		else ctx.ui.notify(`No API key for ${selected.provider}/${selected.id}`, "error");
	}

	pi.on("session_start", async (event, ctx) => {
		const isExplicitNewSession = event.reason === "new";
		const isFreshStartupSession =
			event.reason === "startup" && ctx.sessionManager.buildSessionContext().messages.length === 0;
		if (!isExplicitNewSession && !isFreshStartupSession) return;
		if (ctx.mode !== "tui") return;

		await openPicker(ctx);
	});

	pi.registerCommand("m", {
		description: "Select model by provider category with search",
		handler: async (_args, ctx) => {
			await openPicker(ctx);
		},
	});

	pi.registerShortcut("ctrl+shift+m", {
		description: "Open categorized model picker",
		handler: async (ctx) => {
			await openPicker(ctx);
		},
	});
}
