module GalleryCustomFilters

private struct QuicksortCallFrame {
  public let LeftIndex: Int32;
  public let RightIndex: Int32;

  public static func Create(leftIndex: Int32, rightIndex: Int32) -> QuicksortCallFrame {
    return QuicksortCallFrame(leftIndex, rightIndex);
  }
}

/*
  Overall code structure taken from https://codeberg.org/adamsmasher/cyberpunk/src/branch/master/cyberpunk/UI/data/quicksort.swift
  Quicksort algorithm taken from
  - https://github.com/Marco4413/GeneratorCanvas/blob/bc8761eaf20bee5964ed3e95b446e433ff8fa728/examples/007-sorting_algorithms/sorting.js#L211
  - https://github.com/Marco4413/GeneratorCanvas/blob/bc8761eaf20bee5964ed3e95b446e433ff8fa728/examples/007-sorting_algorithms/sorting.js#L166
*/
public final class QuicksortScreenshot {
  public static func Sort(items: script_ref<array<GameScreenshotInfo>>, comparator: ref<ScreenshotInfoComparator>, leftIndex: Int32, rightIndex: Int32) -> Void {
    // I don't know how big the stack used by redscript is.
    // However, a crash with many screenshots was reported, this MAY solve the issue.
    let quicksortCallStack: array<QuicksortCallFrame>;
    ArrayPush(quicksortCallStack, QuicksortCallFrame.Create(leftIndex, rightIndex));

    while ArraySize(quicksortCallStack) > 0 {
      let params = ArrayPop(quicksortCallStack);
      if params.RightIndex-params.LeftIndex > 1 {
        let r = QuicksortScreenshot.Partition(items, comparator, params.LeftIndex, params.RightIndex);
        ArrayPush(quicksortCallStack, QuicksortCallFrame.Create(params.LeftIndex, r));
        ArrayPush(quicksortCallStack, QuicksortCallFrame.Create(r+1, params.RightIndex));
      }
    }
  }

  private static func Partition(items: script_ref<array<GameScreenshotInfo>>, comparator: ref<ScreenshotInfoComparator>, leftIndex: Int32, rightIndex: Int32) -> Int32 {
    let tempItem: GameScreenshotInfo;

    let i: Int32 = leftIndex;
    let j: Int32 = rightIndex-1;
    // Pick the item in the middle of the array as the pivot
    let pivot: GameScreenshotInfo = Deref(items)[(leftIndex+rightIndex)/2];

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

public abstract class ScreenshotInfoComparator {
  public func Compare(const left: script_ref<GameScreenshotInfo>, const right: script_ref<GameScreenshotInfo>) -> Int32 {
    return 0; /* Return -1 if left < right, 1 if left > right, 0 if left = right */
  }
}
