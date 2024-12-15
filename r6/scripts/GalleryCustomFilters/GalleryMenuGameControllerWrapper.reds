module GalleryCustomFilters

@addField(GalleryMenuGameController)
private let m_GCFCustomFilters: array<ref<GalleryCustomFilter>>;

@wrapMethod(GalleryMenuGameController)
private func SetupFilters() {
  let customFilters: array<ref<GalleryCustomFilter>>;
  this.GCF_GetCustomFilters(customFilters);

  for customFilter in customFilters {
    let filterButton = this.SpawnFromLocal(inkWidgetRef.Get(this.m_filtersGrid) as inkCompoundWidget, n"filterButtonItem").GetController() as GalleryFilterController;
    customFilter.SetController(filterButton);
  }

  wrappedMethod();

  for customFilter in customFilters {
    customFilter.Setup(this.m_tooltipsManager);
    let controller = customFilter.GetController();
    controller.RegisterToCallback(n"OnRelease", this, n"OnItemFilterClick");
    ArrayPush(this.m_filterButtons, controller);
  }

  this.m_GCFCustomFilters = customFilters;
}

@wrapMethod(GalleryMenuGameController)
private func SortScreenshots() {
  let isCustomFilterActive = false;
  for customFilter in this.m_GCFCustomFilters {
    let filterController = customFilter.GetController();
    if Equals(this.m_activeSort, filterController) {
      isCustomFilterActive = true;

      let sortedScreenshotInfos: array<GameScreenshotInfo>;
      // Copy favourites or all screenshots
      for x in this.m_screenshotInfos {
        let isFavourite = !this.m_isFavoriteFiltering || this.m_favoriteManager.IsFavorite(x.pathHash);
        if customFilter.FilterScreenshot(x, isFavourite) {
          ArrayPush(sortedScreenshotInfos, x);
        }
      }

      customFilter.SortScreenshots(sortedScreenshotInfos);
      this.m_sortedScreenshotInfos = sortedScreenshotInfos;

      break;
    }
  }

  if !isCustomFilterActive {
    wrappedMethod();
  }
}
