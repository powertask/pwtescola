class CreateArctits < ActiveRecord::Migration[5.0]
  def change
    create_table :arctits do |t|
      t.decimal :tit_codi
      t.decimal :tit_sequ
      t.decimal :tit_tipo
      t.string :tit_numt
      t.string :tit_fili
      t.decimal :tit_plan
      t.date :tit_dven
      t.decimal :tit_vpar
      t.decimal :tit_vtpr
      t.string :tit_situ
      t.decimal :tit_vrec
      t.decimal :tit_vdev
      t.date :tit_demi
      t.string :tit_indi
      t.decimal :tit_fato
      t.decimal :tit_frej
      t.date :tit_dure
      t.decimal :tit_boen
      t.date :tit_boed
      t.decimal :tit_bodv
      t.date :tit_bodd
      t.decimal :tit_bodm
      t.string :tit_bods
      t.date :tit_dtit
      t.date :tit_datu
      t.string :tit_oper
      t.decimal :tit_vpgp
      t.date :tit_dbol
      t.decimal :tit_nbol
      t.string :tit_ebol
      t.decimal :tit_fgta
      t.string :tit_clie
      t.string :tit_came
      t.string :tit_ccar
      t.date :tit_dret
      t.date :tit_dcar
      t.string :tit_cass
      t.date :tit_deas
      t.date :tit_dras
      t.date :tit_decl
      t.date :tit_drcl
      t.string :tit_re20
      t.decimal :tit_re21
      t.string :tit_nonu
      t.date :tit_dcad
      t.string :tit_ckrg
      t.decimal :tit_pl98
      t.decimal :tit_pc98
    end
  end
end
