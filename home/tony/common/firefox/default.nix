{ inputs, lib, ... }:
let
  extensions = {
    "uBlock0@raymondhill.net" = "ublock-origin";
    "@testpilot-containers" = "multi-account-containers";
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
    "{3c078156-979c-498b-8990-85f7987dd929}" = "sidebery";
    "floccus@handmadeideas.org" = "floccus";
    "{a8f7e9c2-4d3b-4a1e-9f8c-7b6d5e4a3c2b}" = "geo-spoof";
    "FirefoxColor@mozilla.com" = "firefox-color";
    "addon@darkreader.org" = "darkreader";
    "{1018e4d6-728f-4b20-ad56-37578a4de76b}" = "flagfox";
    "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = "auto-tab-discard";
    "addon@fastforward.team" = "fastforwardteam";
    "sponsorBlocker@ajay.app" = "sponsorblock";
    "deArrow@ajay.app" = "dearrow";
    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
    "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = "styl-us";
    "clipper@obsidian.md" = "web-clipper-obsidian";
    "@react-devtools" = "react-devtools";
    "harper@writewithharper.com" = "private-grammar-checker-harper";
    "izer@camelcamelcamel.com" = "the-camelizer-price-history-ch";
    "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = "view-page-archive";
    "{287dcf75-bec6-4eec-b4f6-71948a2eea29}" = "view-image";
    "{57e8684d-5ae8-47d6-93c9-f870ef0e40a3}" = "volume-control-boost-volume";
    "newtaboverride@agenedia.com" = "new-tab-override";
  };
  privateBrowsing = [
    "uBlock0@raymondhill.net"
    "{446900e4-71c2-419f-a6a7-df9c091e268b}"
  ];
  navbar = [
    "{446900e4-71c2-419f-a6a7-df9c091e268b}"
    "clipper@obsidian.md"
    "addon@darkreader.org"
    "{57e8684d-5ae8-47d6-93c9-f870ef0e40a3}"
    "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}"
  ];
  sanitizeExceptions = [
    "google.com"
    "accounts.google.com"
    "youtube.com"
    "proton.me"
    "reddit.com"
    "x.com"
    "news.ycombinator.com"
    "github.com"
    "gitlab.com"
    "tuxcloud.xyz"
    "atlassian.net"
    "ouredge.com"
    "grafana.net"
    "linear.app"
    "posthog.com"
    "miro.com"
  ];
  tabsPanel =
    id: attrs:
    {
      type = 2;
      inherit id;
      color = "toolbar";
      iconIMGSrc = "";
      iconIMG = "";
      lockedPanel = false;
      skipOnSwitching = false;
      noEmpty = false;
      newTabCtx = "none";
      dropTabCtx = "none";
      moveRules = [ ];
      moveExcludedTo = -1;
      bookmarksFolderId = -1;
      newTabBtns = [ ];
      srcPanelConfig = null;
    }
    // attrs;
  sidebery = {
    settings = {
      activateOnMouseUp = false;
      density = "compact";
      hideEmptyPanels = false;
      nativeHighlight = false;
      navBtnCount = false;
      navSwitchPanelsWheel = true;
      pinnedTabsPosition = "panel";
      previewTabsDelay = 500;
      previewTabsInlineHeight = 70;
      previewTabsMode = "i";
      scrollThroughTabsGlobPinIsolate = true;
      snapExcludePrivate = false;
      tabsSecondClickActPrev = true;
    };
    sidebar = {
      nav = [
        "my4u08jonLcH"
        "_F27CySfgYdH"
        "8IReB6J-FKa2"
        "sp-0"
        "history"
        "settings"
      ];
      panels = {
        my4u08jonLcH = tabsPanel "my4u08jonLcH" {
          name = "Tabs";
          iconSVG = "icon_circle";
        };
        _F27CySfgYdH = tabsPanel "_F27CySfgYdH" {
          name = "Work";
          color = "orange";
          iconSVG = "briefcase";
          newTabCtx = "firefox-container-2";
          dropTabCtx = "firefox-container-2";
        };
        "8IReB6J-FKa2" = tabsPanel "8IReB6J-FKa2" {
          name = "Focus";
          color = "orange";
          iconSVG = "icon_coffee";
        };
        history = {
          type = 4;
          id = "history";
          name = "History";
          color = "toolbar";
          iconSVG = "icon_clock";
          tempMode = false;
          lockedPanel = false;
          skipOnSwitching = false;
          viewMode = "history";
        };
      };
    };
  };
in
{
  # firefox
  catppuccin.firefox.force = true;
  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DontCheckDefaultBrowser = true;
      SkipTermsOfUse = true;
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DNSOverHTTPS.Enabled = false;
      GenerativeAI.Enabled = false;
      FirefoxHome = {
        SponsoredTopSites = false;
        SponsoredStories = false;
        Stories = false;
      };
      FirefoxSuggest = {
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
      };
      SearchEngines.Default = "DuckDuckGo";
      SanitizeOnShutdown = {
        Cache = true;
        Cookies = true;
        FormData = true;
        History = false;
        Exceptions = map (d: "https://${d}") sanitizeExceptions;
      };
      "3rdparty".Extensions."uBlock0@raymondhill.net" = {
        toOverwrite.filterLists = [
          "user-filters"
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
          "easylist"
          "easyprivacy"
          "urlhaus-1"
          "plowe-0"
          "adguard-spyware-url"
          "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
          "ublock-cookies-adguard"
          "block-lan"
        ];
        toAdd.trustedSiteDirectives = [ "checkout.stripe.com" ];
      };
      "3rdparty".Extensions."{3c078156-979c-498b-8990-85f7987dd929}" = sidebery;
      "3rdparty".Extensions."newtaboverride@agenedia.com".url = "https://tuxcloud.xyz";
      ExtensionSettings = lib.mapAttrs (id: slug: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
        installation_mode = "force_installed";
        private_browsing = lib.elem id privateBrowsing;
        default_area = if lib.elem id navbar then "navbar" else "menupanel";
      }) extensions;
    };
    profiles.default = {
      preConfig = builtins.readFile "${inputs.betterfox}/user.js";
      containersForce = true;
      containers.Work = {
        id = 2;
        color = "orange";
        icon = "briefcase";
      };
      settings = {
        "browser.startup.page" = 3;
        "extensions.webextensions.ExtensionStorageIDB.enabled" = true;
        "extensions.webextensions.keepStorageOnUninstall" = true;
        "security.cert_pinning.enforcement_level" = 2;
        "browser.bookmarks.defaultLocation" = "toolbar_____";
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.translations.enable" = false;
        "general.autoScroll" = true;
        "media.eme.enabled" = true;
        "sidebar.visibility" = "hide-on-close";
        "sidebar.main.tools" = lib.concatStringsSep "," [
          "history"
          "bookmarks"
          "{446900e4-71c2-419f-a6a7-df9c091e268b}"
          "{3c078156-979c-498b-8990-85f7987dd929}"
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}"
        ];
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "vertical-spacer"
              "urlbar-container"
              "downloads-button"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
              "clipper_obsidian_md-browser-action"
              "addon_darkreader_org-browser-action"
              "_57e8684d-5ae8-47d6-93c9-f870ef0e40a3_-browser-action"
              "_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action"
              "unified-extensions-button"
              "reset-pbm-toolbar-button"
            ];
            PersonalToolbar = [ "personal-bookmarks" ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
            toolbar-menubar = [ "menubar-items" ];
          };
          currentVersion = 26;
        };
      };
      userChrome = ''
        #TabsToolbar { visibility: collapse !important; }
        #sidebar-header { visibility: collapse !important; }
      '';
    };
  };
}
