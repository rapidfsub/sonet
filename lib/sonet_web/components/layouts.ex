defmodule SonetWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use SonetWeb, :controller` and
  `use SonetWeb, :live_view`.
  """
  use SonetWeb, :html

  embed_templates "layouts/*"
end
