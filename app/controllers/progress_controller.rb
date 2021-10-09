class ProgressController < ApplicationController
  def total
    total = -> { Entry.includes(:project_file)
                      .references(:project_file)
                      .where("(source != '(null)') and (source != '')")
                      .group("project_files.type")
                      .count }
    have_contents = -> { Entry.includes(:project_file)
                              .references(:project_file)
                              .where("(source != '(null)') and (source != '') and ((chinese != '') or (entries.status = 4))")
                              .group("project_files.type")
                              .count }

    @total = total.call
    @have_contents = have_contents.call
    @percentage = @total.map { |key, value| {key => ((@have_contents[key] || 0) / value.to_f * 100).round(3)} }.reduce(&:merge)
  end
end
