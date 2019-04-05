class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
    	t.string :url, null: false, comment: "长链接"
    	t.string :keyword, null: false, index: true, comment: "短链接码"
    	t.integer :link_type, null: false, comment: "系统: system 自定义: custom"
    	t.integer :hits, null:false, default: 0, comment: "点击量"

      t.timestamps
    end
  end
end
