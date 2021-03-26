task :dump_data do
  `pg_dump -d 'singinghill_development' > db/development.sql` # -t '(entries|nouns|project_files|users)' --exclude-table-data 'users'
end
