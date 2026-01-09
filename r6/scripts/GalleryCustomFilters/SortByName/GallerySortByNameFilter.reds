module GalleryCustomFilters.SortByName

import GalleryCustomFilters.*
import GalleryCustomFilters.Comparators.*
import GalleryCustomFilters.Config.GalleryDefaultFiltersConfig
import GalleryCustomFilters.Utils.GetFilename

@if(ModuleExists("Codeware.UI.TextInput"))
import Codeware.UI.*

// See GalleryCustomFilter for what methods are actually required
public class GallerySortByNameFilter extends GalleryCustomFilter {
  private let m_config: ref<GalleryDefaultFiltersConfig>;

  @if(ModuleExists("Codeware.UI.TextInput"))
  private let m_searchInput: ref<HubTextInput>;
  private let m_searchText: String;

  public static func Create(config: ref<GalleryDefaultFiltersConfig>) -> ref<GallerySortByNameFilter> {
    let filter = new GallerySortByNameFilter();
    filter.m_config = config;
    filter.m_searchText = "";
    return filter;
  }

  public func Setup(tooltipsManager: wref<gameuiTooltipsManager>) {
    let locKey = n"UI-Sorting-Name";
    let iconName = "UIIcon.Filter_AllItems";

    this.SetupController(locKey, iconName, tooltipsManager);
  }

  @if(!ModuleExists("Codeware.UI.TextInput"))
  public func ReparentSettings(newParent: wref<inkCompoundWidget>) {}

  @if(!ModuleExists("Codeware.UI.TextInput"))
  public func ToggleSettings(on: Bool) {}

  @if(!ModuleExists("Codeware.UI.TextInput"))
  private func GetSearchText() -> String { return ""; }

  public func SortScreenshots(screenshots: script_ref<array<GameScreenshotInfo>>) {
    let sortOrder = this.GetSortOrder();
    if Equals(sortOrder, GalleryCustomFilterSortOrder.Ascending) {
      let nameComparator = ScreenshotInfoNameAscComparator.Create();
      this.SortScreenshots(screenshots, nameComparator);
    } else {
      let nameComparator = ScreenshotInfoNameDesComparator.Create();
      this.SortScreenshots(screenshots, nameComparator);
    }
  }

  public func FilterScreenshot(screenshot: GameScreenshotInfo, isFavourite: Bool) -> Bool {
    if !isFavourite {
      return false;
    }
    
    let filename = GetFilename(screenshot.path);
    if this.m_config.SortByNameShowOnlyCustomImages {
      if StrBeginsWith(filename, "photomode_") {
        return false;
      }
    }

    if this.m_config.SortByNameShowSearchInput && StrLen(this.m_searchText) > 0 {
      if !StrContains(StrLower(filename), this.m_searchText) {
        return false;
      }
    }

    return true;
  }

  protected cb func OnSearchInput(widget: wref<inkWidget>) {
    this.m_searchText = this.GetSearchText();
    this.NotifyFilterSettingsChanged();
  }

  @if(ModuleExists("Codeware.UI.TextInput"))
  public func ReparentSettings(newParent: wref<inkCompoundWidget>) {
    if IsDefined(this.m_searchInput) {
      this.m_searchInput.Reparent(newParent);
    } else {
      let locKey = n"UI-Sorting-Name";
      let searchInput = HubTextInput.Create();
      searchInput.SetName(n"SearchInput");
      searchInput.SetDefaultText(GetLocalizedTextByKey(locKey));
      searchInput.SetMaxLength(128);
      searchInput.Reparent(newParent);
      searchInput.RegisterToCallback(n"OnInput", this, n"OnSearchInput");
      this.m_searchInput = searchInput;
    }
  }

  @if(ModuleExists("Codeware.UI.TextInput"))
  public func ToggleSettings(on: Bool) {
    if IsDefined(this.m_searchInput) {
      this.m_searchInput.GetRootWidget().SetVisible(
          this.m_config.SortByNameShowSearchInput && on);
    }
  }

  @if(ModuleExists("Codeware.UI.TextInput"))
  private func GetSearchText() -> String {
    return StrLower(this.m_searchInput.GetText());
  }
}

@wrapMethod(GalleryMenuGameController)
private func GCF_GetCustomFilters(customFilters: script_ref<array<ref<GalleryCustomFilter>>>) {
  wrappedMethod(customFilters);

  let config = GalleryDefaultFiltersConfig.GetInstance();
  if config.SortByNameEnabled {
    ArrayPush(Deref(customFilters), GallerySortByNameFilter.Create(config));
  }
}
