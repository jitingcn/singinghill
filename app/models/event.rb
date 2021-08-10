class Event < ProjectFile
  default_scope -> { reorder(Arel.sql("CAST(substring(name from '[0-9]+') AS int)")) }
end

