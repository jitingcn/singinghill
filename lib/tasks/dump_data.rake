task :dump_data do
  `pg_dump -d 'singinghill_development' -t '(entries|nouns|project_files|users)' --exclude-table-data 'users' > db/development.sql`
end
