module GalleryCustomFilters.SortByName

import GalleryCustomFilters.*
import GalleryCustomFilters.Comparators.*

public class GallerySortByNameFilter extends GalleryCustomFilter {
  public static func Create() -> ref<GallerySortByNameFilter> {
    return new GallerySortByNameFilter();
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

  /* The only thing this filter does is sorting */
  public func FilterScreenshot(screenshot: GameScreenshotInfo, isFavourite: Bool) -> Bool {
    return super.FilterScreenshot(screenshot, isFavourite);
  }
}

@wrapMethod(GalleryMenuGameController)
private func GCF_GetCustomFilters(customFilters: script_ref<array<ref<GalleryCustomFilter>>>) {
  wrappedMethod(customFilters);
  ArrayPush(Deref(customFilters), GallerySortByNameFilter.Create());
}
