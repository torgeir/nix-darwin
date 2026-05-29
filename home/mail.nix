{ inputs, pkgs, ... }: {

  programs.mbsync = {
    enable = true;
    extraConfig = ''
      Create Near
      Expunge Both
      SyncState *

      # gmail ========================
      IMAPAccount gmail
      Host imap.gmail.com
      UserCmd "echo $USER_EMAIL"
      PassCmd "${pkgs.coreutils}/bin/timeout 10s ${pkgs.gnupg}/bin/gpg -q --no-tty --batch -d ~/.authinfo.gpg | ${pkgs.gawk}/bin/awk -v login=\"$USER_EMAIL\" '$0 ~ \"^machine imap\\\\.gmail\\\\.com login \" login \" port 993 password \" { print $NF; exit }'" 
      Port 993
      TLSType IMAPS
      TLSVersions +1.2
      SystemCertificates no
      CertificateFile /etc/ssl/certs/ca-certificates.crt

      IMAPStore gmail-remote
      Account gmail

      MaildirStore gmail-local
      SubFolders Verbatim
      Path ~/.maildir/gmail/
      Inbox ~/.maildir/gmail/INBOX

      Channel gmail
      Far :gmail-remote:
      Near :gmail-local:
      Patterns INBOX
      MaxMessages 50
      Sync PullNew Flags

      # junk =========================
      IMAPAccount junk
      Host imap.gmail.com
      UserCmd "echo $USER_EMAIL_2"
      PassCmd "${pkgs.coreutils}/bin/timeout 10s ${pkgs.gnupg}/bin/gpg -q --no-tty --batch -d ~/.authinfo.gpg | ${pkgs.gawk}/bin/awk -v login=\"$USER_EMAIL_2\" '$0 ~ \"^machine imap\\\\.gmail\\\\.com login \" login \" port 993 password \" { print $NF; exit }'"
      Port 993
      TLSType IMAPS
      TLSVersions +1.2
      SystemCertificates no
      CertificateFile /etc/ssl/certs/ca-certificates.crt

      IMAPStore junk-remote
      Account junk

      MaildirStore junk-local
      SubFolders Verbatim
      Path ~/.maildir/junk/
      Inbox ~/.maildir/junk/INBOX

      Channel junk
      Far :junk-remote:
      Near :junk-local:
      Patterns INBOX
      MaxMessages 50
      Sync PullNew Flags
    '';
  };
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = { preNew = "${pkgs.isync}/bin/mbsync --all"; };
    extraConfig = { database = { path = "/Users/torgeir/.maildir"; }; };
  };

  programs.info.enable =
    true; # ensures INFOPATH is set, so manuals can be found

  home.packages = with pkgs; [ notmuch.info ];

  accounts.email.accounts = {
    "torgeir.thoresen@gmail.com" = {
      primary = true;
      realName = "Torgeir Thoresen";
      userName = "torgeir.thoresen@gmail.com";
      address = "torgeir.thoresen@gmail.com";
      gpg = {
        # https://keybase.io/torgeir
        key = "922E681804CA8D82F1FAFCB177836712DAEA8B95";
        signByDefault = true;
      };
      notmuch.enable = true;
    };
  };

  # systemd.user.services.notmuch-new = {
  #   Unit = { Description = "Run notmuch new to fetch email"; };
  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = "${pkgs.notmuch}/bin/notmuch new";
  #   };
  # };

  # systemd.user.timers.notmuch-new = {
  #   Unit = { Description = "Run notmuch new periodically"; };
  #   Timer = {
  #     OnBootSec = "2m";
  #     OnUnitActiveSec = "5m";
  #     Persistent = true;
  #   };
  #   Install = { WantedBy = [ "timers.target" ]; };
  # };

}
