require_relative "20231029014646_create_articles"

class RevertCreateArticles < ActiveRecord::Migration[7.0]
  def change
    revert CreateArticles
  end
end
