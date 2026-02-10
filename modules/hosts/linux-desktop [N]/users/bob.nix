{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.linux-desktop =
    { config, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        with inputs.self.factory;
        [
          bob
          /*
            TODO
            (mount-cifs-nixos {
            host = "home-server.lan";
            resource = "home";
            destination = "/home/users/bob/homeserver";
            credentialspath = "${config.age.secrets."homeserver-cred".path}";
            UID = "bob";
            GID = "users";
            })
          */
        ];
      /*
        TODO
           age.secrets."homeserver-cred" = {
             file = "${self.inputs.secrets}/homeserver-cred.age";
           };
      */
      # ...

      home-manager.users.bob = {
        ###
      };
    };
}
