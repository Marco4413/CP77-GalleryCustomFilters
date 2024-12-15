module GalleryCustomFilters

@addMethod(GalleryFilterController)
public final func GCF_GetIcon() -> inkImageRef {
  return this.m_icon;
}
