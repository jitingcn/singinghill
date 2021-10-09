json.status do
  json.array! @total.keys do |type|
    json.type type
    json.total @total[type]
    json.have_contents @have_contents[type] || 0
    json.percentage @percentage[type]
  end
end
