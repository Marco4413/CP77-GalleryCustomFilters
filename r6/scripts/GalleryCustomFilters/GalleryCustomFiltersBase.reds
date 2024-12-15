module GalleryCustomFilters

import GalleryCustomFilters.Comparators.ScreenshotInfoDateAscComparator
import GalleryCustomFilters.Comparators.ScreenshotInfoDateDesComparator

public enum GalleryCustomFilterSortOrder {
  Ascending = 1,
  Descending = 2,
}

public abstract class GalleryCustomFilter {
  private let m_controller: ref<GalleryFilterController>;

  public final func SetController(controller: ref<GalleryFilterController>) {
    this.m_controller = controller;
  }

  public final func GetController() -> wref<GalleryFilterController> {
    return this.m_controller;
  }

  public final func GetSortOrder() -> GalleryCustomFilterSortOrder {
    let filterType = this.m_controller.GetFilterType();
    if Equals(filterType, inkGameScreenshotSortMode.DateAscending) {
      return GalleryCustomFilterSortOrder.Ascending;
    } else {
      return GalleryCustomFilterSortOrder.Descending;
    }
  }

  private func SetupController(locKey: CName, iconName: String, tooltipsManager: wref<gameuiTooltipsManager>) {
    let filterType = inkGameScreenshotSortMode.DateAscending;
    this.m_controller.Setup(filterType, n"", locKey, tooltipsManager);

    let filterIcon = this.m_controller.GCF_GetIcon();
    InkImageUtils.RequestSetImage(this.m_controller, filterIcon, iconName);
  }

  private func SortScreenshots(screenshots: script_ref<array<GameScreenshotInfo>>, comparator: ref<ScreenshotInfoComparator>) {
    QuicksortScreenshot.Sort(screenshots, comparator, 0, ArraySize(Deref(screenshots)));
  }

  /* This method must be overridden to setup the icon and tooltip for m_controller.
     The SetupController method is an helper to quickly set it up given a locKey and iconName.
  */
  public abstract func Setup(tooltipsManager: wref<gameuiTooltipsManager>);

  /* Override this method to change the sorting behaviour of the filter.
     The screenshots argument holds a reference to the array that needs to be sorted.
     A Quicksort implementation is found in the QuicksortScreenshot.reds file.
     As well as some default Comparators in the GalleryComparators.reds file.
  */
  public func SortScreenshots(screenshots: script_ref<array<GameScreenshotInfo>>) {
    // Default behaviour is to sort by date.
    // This can also be copy-pasted to quickly develop an alternative implementation.
    let sortOrder = this.GetSortOrder();
    if Equals(sortOrder, GalleryCustomFilterSortOrder.Ascending) {
      let nameComparator = new ScreenshotInfoDateAscComparator();
      this.SortScreenshots(screenshots, nameComparator);
    } else {
      let nameComparator = new ScreenshotInfoDateDesComparator();
      this.SortScreenshots(screenshots, nameComparator);
    }
  }

  /* If this function returns true, the given screenshot will be shown in the menu.
     isFavourite is true if the screenshot was not filtered out by the vanilla filtering behaviour.
  */
  public func FilterScreenshot(screenshot: GameScreenshotInfo, isFavourite: Bool) -> Bool {
    return isFavourite;
  }
}

@addMethod(GalleryMenuGameController)
private func GCF_GetCustomFilters(customFilters: script_ref<array<ref<GalleryCustomFilter>>>) {
  /*
  This method must be wrapped to provide new custom filters.
  A call to `wrappedMethod(customFilters)` must be performed.
  Custom filters must be added to customFilters:
    `ArrayPush(Deref(customFilters), new MyCustomFilter())`
  */
}
