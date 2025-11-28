{
  inputs,
  config,
  user,
  ...
}:
{

  services.northstar-dedicated = {
    enable = true;
    openFirewall = true;
    profile = {
      port = 37015;

      package-names = [
        {
          name = "cat_or_not-AmpedMobilepoints-0.0.7";
          sha256 = "sha256-S39V05bDti+MG5L1VOPF61EjUFYNohfBgwoSuBM0wws=";
        }
        {
          name = "skrubslayer69-mp_sanctuary-0.0.3";
          sha256 = "sha256-4sKqD4CmCUENEQ8OKUfyh3uPNcjHZxzfKJO31aSl93A=";
        }
        {
          name = "Berdox-MP_Chroma_Null_Surf-1.1.1";
          sha256 = "sha256-GjFrv2v/StrFqx9yd0ectsOI0mtj0nrdvGlAvUZLf7w=";
        }
        {
          name = "Berdox-Gauntlet_Framework-0.5.6";
          sha256 = "sha256-noyjYEVyg185/GU8j9JcXcA/nVvjPPwrK9aauDZg8ko=";
        }
        {
          name = "Berdox-Surf_Game_Mode-1.1.6";
          sha256 = "sha256-5SZ24KcpnoXEU45e+FyqOFFRjOl3I2qmBpBPZ+bJHkM=";
        }
        {
          name = "Berdox-Surf_Game_Mode-1.1.6";
          sha256 = "sha256-5SZ24KcpnoXEU45e+FyqOFFRjOl3I2qmBpBPZ+bJHkM=";
        }
        {
          name = "ASillyNeko-Onslaught-1.0.4";
          sha256 = "sha256-hsXpqHrxqc0iBfUrOLtfovonCeQ5YT76JRPxXFFmuhU=";
        }
      ];
      bp-ort.enable = true;
      rcon = {
        enable = true;
        sshKeys = config.users.users.${user}.openssh.authorizedKeys.keys + [ # TODO: add extra keys for people to access rcon only
         ];
      };
      playlistRotations = {
        enable = true;
        playlistDefinition = ''
          currentPlaylist = InitPlaylistRotation( "mcp", ePlaylistRotationType.GAMEMODE, "mcp" )
          playlists.append( currentPlaylist )    

          currentPlaylist = InitPlaylistRotation( "surf", ePlaylistRotationType.GAMEMODE, "surf", "mp_chroma_null_surf" )
          currentPlaylist.timeOverwrite = 1800.0
          playlists.append( currentPlaylist )    

          currentPlaylist = InitPlaylistRotation( "mp_sanctuary", ePlaylistRotationType.MAP, "tdm", "mp_sanctuary" )
          playlists.append( currentPlaylist )

          currentPlaylist = InitPlaylistRotation( "onslaught", ePlaylistRotationType.GAMEMODE, "onslaught", "mp_forwardbase_kodai" )
          playlists.append( currentPlaylist )    
        '';
      };

      ns_server_name = "modjam server";
      ns_server_desc = "server for modjam playtesting period";
      ns_should_return_to_lobby = 1;
      ns_private_match_only_host_can_change_settings = 2;
      ns_private_match_only_host_can_start = 1;
      ns_private_match_countdown_length = 15;
      ns_private_match_last_mode = "mcp";
      ns_private_match_last_map = "mp_glitch";
      net_chan_limit_mode = 2;

      playlistVars = [
        "max_players 12"
        "playlist private_match"
      ];
    };

    extraArgs = [
      "-nopakdedi"
      "+setplaylist private_match"
    ];
  };
}
