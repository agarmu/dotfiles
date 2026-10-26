import AppKit
import CoreText

guard CommandLine.arguments.count == 5,
      let size = Double(CommandLine.arguments[4]), size.isFinite, size > 0 else {
    fatalError("usage: plist-font-patcher INPUT OUTPUT FONT-FILE SIZE (positive point size)")
}

let profileURL = URL(fileURLWithPath: CommandLine.arguments[1])
let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])
let fontURL = URL(fileURLWithPath: CommandLine.arguments[3])
let input = try Data(contentsOf: profileURL)
guard var profile = try PropertyListSerialization.propertyList(
    from: input, format: nil
) as? [String: Any] else {
    fatalError("Profile must be a plist dictionary")
}

guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(fontURL as CFURL)
    as? [NSFontDescriptor], descriptors.count == 1 else {
    fatalError("Supply a font file containing exactly one face")
}
var registrationError: Unmanaged<CFError>?
guard CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &registrationError) else {
    fatalError("Font registration failed: \(String(describing: registrationError?.takeRetainedValue()))")
}
guard let font = NSFont(descriptor: descriptors[0], size: CGFloat(size)) else {
    fatalError("Cannot create font")
}

profile["Font"] = try NSKeyedArchiver.archivedData(
    withRootObject: font, requiringSecureCoding: false
)
let output = try PropertyListSerialization.data(fromPropertyList: profile, format: .xml, options: 0)
try output.write(to: outputURL, options: .atomic)
