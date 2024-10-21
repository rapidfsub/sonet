defmodule SonetLib.Slugex do
  def title_slug(text, datetime \\ DateTime.utc_now()) do
    slug = Slug.slugify(text, truncate: 50)
    offset = DateTime.to_unix(datetime)
    hash = :erlang.phash2(slug <> to_string(offset))
    slug <> "-" <> to_string(hash)
  end
end
