defmodule Koueki.Validation.Category do
  def valid_categories do
    ["Antivirus detection", "Artifacts dropped", "Attribution", "External analysis",
     "Financial fraud", "Internal reference", "Network activity", "Other",
     "Payload delivery", "Payload installation", "Payload type", "Persistence mechanism",
     "Person", "Social network", "Support Tool", "Targeting data"]
  end
end
