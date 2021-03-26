task :dump_data do
  `pg_dump -d 'singinghill_development' > data/development.sql` # -t '(entries|nouns|project_files|users)' --exclude-table-data 'users'
end
