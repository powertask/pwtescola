class DebtorValidator < ActiveModel::Validator
  def validate(record)
    
    if record[:cnpj].nil? && record[:cpf].nil?
#      record.errors[:cnpj] << 'CNPJ ou CPF devem ser preenchidos.'
#      record.errors[:cpf] << 'CNPJ ou CPF devem ser preenchidos.'
    end

    if record[:cnpj].present? && record[:cpf].present?
#      record.errors[:cnpj] << 'CNPJ ou CPF não devem ser preenchidos simultaneamente.'
    end
  end
end
