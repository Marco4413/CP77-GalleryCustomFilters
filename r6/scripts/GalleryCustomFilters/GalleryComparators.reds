module GalleryCustomFilters.Comparators

import GalleryCustomFilters.ScreenshotInfoComparator

public class ScreenshotInfoNameAscComparator extends ScreenshotInfoComparator {
  public func Compare(const left: script_ref<GameScreenshotInfo>, const right: script_ref<GameScreenshotInfo>) -> Int32 {
    return StrCmp(Deref(left).path, Deref(right).path);
  }
}

public class ScreenshotInfoNameDesComparator extends ScreenshotInfoComparator {
  public func Compare(const left: script_ref<GameScreenshotInfo>, const right: script_ref<GameScreenshotInfo>) -> Int32 {
    return StrCmp(Deref(right).path, Deref(left).path);
  }
}
