defmodule HeadsUpWeb.TipController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Tips

  def show(conn, %{"id" => id}) do
    tip = Tips.get_tip(id)
    render(conn, :show, tip: tip)
  end

  def index(conn, _params) do
    tips = Tips.list_tips()
    render(conn, :index, tips: tips)
  end

end
