module GalleryCustomFilters.Comparators

import GalleryCustomFilters.ScreenshotInfoComparator

public final class ScreenshotInfoNameAscComparator extends ScreenshotInfoComparator {
  public func Compare(const left: script_ref<GameScreenshotInfo>, const right: script_ref<GameScreenshotInfo>) -> Int32 {
    return StrCmp(Deref(left).path, Deref(right).path);
  }
}

public final class ScreenshotInfoNameDesComparator extends ScreenshotInfoComparator {
  public func Compare(const left: script_ref<GameScreenshotInfo>, const right: script_ref<GameScreenshotInfo>) -> Int32 {
    return StrCmp(Deref(right).path, Deref(left).path);
  }
}

public final class ScreenshotInfoDateAscComparator extends ScreenshotInfoComparator {
  public func Compare(const left: script_ref<GameScreenshotInfo>, const right: script_ref<GameScreenshotInfo>) -> Int32 {
    // A bit weird but they're unsigned. Can't just return(leftDate - rightDate)
    let leftDate = Deref(left).creationDate;
    let rightDate = Deref(right).creationDate;
    if leftDate > rightDate {
      return 1;
    } else if leftDate < rightDate {
      return -1;
    } else {
      return 0;
    }
  }
}

public final class ScreenshotInfoDateDesComparator extends ScreenshotInfoComparator {
  public func Compare(const left: script_ref<GameScreenshotInfo>, const right: script_ref<GameScreenshotInfo>) -> Int32 {
    let leftDate = Deref(left).creationDate;
    let rightDate = Deref(right).creationDate;
    if leftDate < rightDate {
      return 1;
    } else if leftDate > rightDate {
      return -1;
    } else {
      return 0;
    }
  }
}
