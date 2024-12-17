module GalleryCustomFilters.Utils

public func GetFilename(const path: script_ref<String>) -> String {
  let pathSepIdx = StrFindLast(path, "\\");
  if pathSepIdx < 0 {
    pathSepIdx = StrFindLast(path, "/");
  }

  if pathSepIdx < 0 {
    return Deref(path);
  }

  return StrMid(path, pathSepIdx+1);
}
