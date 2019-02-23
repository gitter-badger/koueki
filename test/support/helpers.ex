defmodule Koueki.TestHelper do
  def gen_ip do
    "#{:random.uniform(255)}.#{:random.uniform(255)}.#{:random.uniform(255)}.#{
      :random.uniform(255)
    }"
  end
end
