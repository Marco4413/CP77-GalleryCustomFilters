module GalleryCustomFilters

@addField(GalleryMenuGameController)
private let m_GCFCustomFilters: array<ref<GalleryCustomFilter>>;

@addField(GalleryMenuGameController)
private let m_GCFActiveCustomFilter: wref<GalleryCustomFilter>;

@addField(GalleryMenuGameController)
private let m_GCFSettingsContainer: ref<inkCompoundWidget>;

@addMethod(GalleryMenuGameController)
private func GCF_SetActiveCustomFilter(customFilter: wref<GalleryCustomFilter>) {
  if Equals(this.m_GCFActiveCustomFilter, customFilter) {
    return;
  }

  if IsDefined(this.m_GCFActiveCustomFilter) {
    this.m_GCFActiveCustomFilter.ToggleSettings(false);
  }

  this.m_GCFActiveCustomFilter = customFilter;

  if IsDefined(this.m_GCFActiveCustomFilter) {
    this.m_GCFActiveCustomFilter.ToggleSettings(true);
  }
}

@addMethod(GalleryMenuGameController)
public func GCF_OnCustomFilterSettingsChanged(customFilter: wref<GalleryCustomFilter>) {
  if Equals(customFilter, this.m_GCFActiveCustomFilter) {
    this.SortScreenshots();
    this.UpdateGalleryView();
  }
}

@wrapMethod(GalleryMenuGameController)
private func SetupFilters() {
  let filtersGrid: wref<inkCompoundWidget> = inkWidgetRef.Get(this.m_filtersGrid) as inkCompoundWidget;

  let container = new inkHorizontalPanel();
  container.SetName(n"GCFSettingsContainer");
  container.SetFitToContent(true);
  container.SetHAlign(inkEHorizontalAlign.Left);
  container.SetVAlign(inkEVerticalAlign.Top);
  container.SetInteractive(true);
  container.SetMargin(5, 0, 5, 0);
  container.Reparent(filtersGrid, -1);
  this.m_GCFSettingsContainer = container;

  let customFilters: array<ref<GalleryCustomFilter>>;
  this.GCF_GetCustomFilters(customFilters);

  for customFilter in customFilters {
    let filterButton = this.SpawnFromLocal(filtersGrid, n"filterButtonItem").GetController() as GalleryFilterController;
    customFilter.SetGalleryController(this);
    customFilter.SetController(filterButton);
  }

  wrappedMethod();

  for customFilter in customFilters {
    customFilter.Setup(this.m_tooltipsManager);
    let controller = customFilter.GetController();
    controller.RegisterToCallback(n"OnRelease", this, n"OnItemFilterClick");

    customFilter.ReparentSettings(this.m_GCFSettingsContainer);
    customFilter.ToggleSettings(false);

    ArrayPush(this.m_filterButtons, controller);
  }

  this.m_GCFCustomFilters = customFilters;
  this.m_GCFActiveCustomFilter = null;
}

@wrapMethod(GalleryMenuGameController)
private func SortScreenshots() {
  let isCustomFilterActive = false;
  for customFilter in this.m_GCFCustomFilters {
    let filterController = customFilter.GetController();
    if Equals(this.m_activeSort, filterController) {
      this.GCF_SetActiveCustomFilter(customFilter);
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
    this.GCF_SetActiveCustomFilter(null);
    wrappedMethod();
  }
}
