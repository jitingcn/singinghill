json.status do
  json.array! @total.keys do |type|
    json.type type
    json.total @total[type]
    json.have_contents @have_contents[type] || 0
    json.proofreading @proofreading[type] || 0
    json.percentage @percentage[type]
    json.proofreading_percentage @proofreading_percentage[type]
  end
end
