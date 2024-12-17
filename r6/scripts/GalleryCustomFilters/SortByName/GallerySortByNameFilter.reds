module GalleryCustomFilters.SortByName

import GalleryCustomFilters.*
import GalleryCustomFilters.Comparators.*
import GalleryCustomFilters.Config.GalleryDefaultFiltersConfig
import GalleryCustomFilters.Utils.GetFilename

// See GalleryCustomFilter for what methods are actually required
public class GallerySortByNameFilter extends GalleryCustomFilter {
  private let m_config: ref<GalleryDefaultFiltersConfig>;

  public static func Create(config: ref<GalleryDefaultFiltersConfig>) -> ref<GallerySortByNameFilter> {
    let filter = new GallerySortByNameFilter();
    filter.m_config = config;
    return filter;
  }

  public func Setup(tooltipsManager: wref<gameuiTooltipsManager>) {
    let locKey = n"UI-Sorting-Name";
    let iconName = "UIIcon.Filter_AllItems";

    this.SetupController(locKey, iconName, tooltipsManager);
  }

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
    if isFavourite && this.m_config.SortByNameShowOnlyCustomImages {
      let filename = GetFilename(screenshot.path);
      return !StrBeginsWith(filename, "photomode_");
    }

    return isFavourite;
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
