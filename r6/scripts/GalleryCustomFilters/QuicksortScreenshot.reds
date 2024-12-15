module GalleryCustomFilters

/*
  Overall code structure taken from https://codeberg.org/adamsmasher/cyberpunk/src/branch/master/cyberpunk/UI/data/quicksort.swift
  Quicksort algorithm taken from
  - https://github.com/Marco4413/GeneratorCanvas/blob/bc8761eaf20bee5964ed3e95b446e433ff8fa728/examples/007-sorting_algorithms/sorting.js#L211
  - https://github.com/Marco4413/GeneratorCanvas/blob/bc8761eaf20bee5964ed3e95b446e433ff8fa728/examples/007-sorting_algorithms/sorting.js#L166
*/
public final class QuicksortScreenshot extends IScriptable {
  public static func Sort(items: script_ref<array<GameScreenshotInfo>>, comparator: ref<ScreenshotInfoComparator>, leftIndex: Int32, rightIndex: Int32) -> Void {
    if rightIndex-leftIndex <= 1 {
      return;
    }

    let r = QuicksortScreenshot.Partition(items, comparator, leftIndex, rightIndex);
    QuicksortScreenshot.Sort(items, comparator, leftIndex, r);
    QuicksortScreenshot.Sort(items, comparator, r+1, rightIndex);
  }

  private static func Partition(items: script_ref<array<GameScreenshotInfo>>, comparator: ref<ScreenshotInfoComparator>, leftIndex: Int32, rightIndex: Int32) -> Int32 {
    let tempItem: GameScreenshotInfo;

    let i: Int32 = leftIndex;
    let j: Int32 = rightIndex-1;
    let pivot: GameScreenshotInfo = Deref(items)[leftIndex];

    while i < j {
      while comparator.Compare(Deref(items)[i], pivot) < 0 {
        i += 1;
      }
      while comparator.Compare(Deref(items)[j], pivot) > 0 {
        j -= 1;
      }

      if i < j {
        tempItem = Deref(items)[i];
        Deref(items)[i] = Deref(items)[j];
        Deref(items)[j] = tempItem;
      }
    }

    return j;
  }
}

public abstract class ScreenshotInfoComparator extends IScriptable {
  public func Compare(const left: script_ref<GameScreenshotInfo>, const right: script_ref<GameScreenshotInfo>) -> Int32 {
    return 0; /* Return -1 if left < right, 1 if left > right, 0 if left = right */
  }
}
