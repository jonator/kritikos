defmodule KritikosWeb.SharedView do
  @pretty_print Mix.env() == :dev
  def pretty_print_date_time(date_time) do
    year =
      if DateTime.utc_now().year == date_time.year do
        ""
      else
        "/#{date_time.year}"
      end

    hour =
      if date_time.hour < 12 do
        " #{date_time.hour}"
      else
        " #{date_time.hour - 12}"
      end

    minutes =
      if date_time.minute < 10 do
        ":0#{date_time.minute}"
      else
        ":#{date_time.minute}"
      end

    meridiem =
      if date_time.hour < 12 do
        " am"
      else
        " pm"
      end

    "#{date_time.month}/#{date_time.day}" <> year <> hour <> minutes <> meridiem
  end

  def to_js_object(data) do
    {:ok, json} = Jason.encode(data, escape: :javascript_safe, pretty: @pretty_print)

    {:safe, json}
  end
end
