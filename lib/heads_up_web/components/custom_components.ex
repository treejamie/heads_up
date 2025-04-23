defmodule HeadsUpWeb.CustomComponents do
  use HeadsUpWeb, :html

  attr :status, :atom, values: [:pending, :resolved, :cancelled], default: :pending
  attr :class, :string, default: nil

  def badge(assigns) do
    ~H"""
      <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :resolved && "text-lime-600 border-lime-600",
      @status == :pending && "text-amber-600 border-amber-600",
      @status == :cancelled && "text-gray-600 border-gray-600",
      @class
      ]}>
      <%= @status %>
    </div>
    """
  end

end
