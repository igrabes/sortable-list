class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.references :book
      t.references :question
      t.references :user
      t.text :answer
      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
