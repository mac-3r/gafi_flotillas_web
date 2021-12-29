class CreateAnswerDetail < ActiveRecord::Migration[6.0]
  def change
    create_table :answer_details do |t|
      t.references :user_answer, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
