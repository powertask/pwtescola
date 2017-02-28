class CreateArcexcls < ActiveRecord::Migration[5.0]
  def change
    create_table :arcexcls do |t|
      t.date :exc_dcad
      t.decimal :exc_tipo
      t.time :exc_hora
      t.decimal :exc_codi
      t.string :exc_cobr
      t.decimal :exc_cmot
      t.string :exc_moti
      t.decimal :exc_reci
      t.decimal :exc_stat
      t.date :exc_dpag
      t.date :exc_dlan
      t.string :exc_auma
      t.decimal :exc_tpgt
      t.string :exc_remi
      t.decimal :exc_vpag
      t.decimal :exc_vpri
      t.decimal :exc_ttit
      t.string :exc_numt
      t.string :exc_fili
      t.decimal :exc_plan
      t.date :exc_dven
      t.decimal :exc_vpar
      t.decimal :exc_vtpr
      t.date :exc_dtit
      t.string :exc_res1
      t.decimal :exc_res2
      t.string :exc_nser
      t.string :exc_clie
      t.decimal :exc_nuac
      t.decimal :exc_npac
      t.decimal :exc_tpac
      t.string :exc_ckrg
      t.string :exc_usuc
      t.string :exc_usua
      t.time :exc_dhor
      t.decimal :exc_coco
      t.decimal :exc_cgru
      t.string :exc_ntel
      t.integer :exc_id
    end
  end
end
