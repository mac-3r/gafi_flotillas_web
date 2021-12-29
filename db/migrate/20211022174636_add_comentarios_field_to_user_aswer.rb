class AddComentariosFieldToUserAswer < ActiveRecord::Migration[6.0]
  def change
    add_column :user_answers, :comentarios, :string, null: true
  end
end
