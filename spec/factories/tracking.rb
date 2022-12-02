FactoryBot.define do
  factory :tracking do
    from { ["ELN", "RARDA4KIT", "REPO"].sample }
    to { ["RARDA4Kit", "RARDA4Chem", "REPO", "nmrXiv"].sample }
    status { ["draft", "published", "submitted"].sample }
    tracker_number { "T221001-ERK-01" }
    metadata {
      {"item1" => "value1",
       "item2" => "value2",
       "item3" => "value3"}
    }
  end
end
