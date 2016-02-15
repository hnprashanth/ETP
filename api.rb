require 'sinatra'
require 'json'

def eHRA
  eligibleHRA = params[:rent].to_i - (params[:basic].to_i * 0.1)
  if eligibleHRA > params[:hra].to_i
    eligibleHRA = params[:hra].to_i
  elsif eligibleHRA < 0
    eligibleHRA = 0
  end
  eligibleHRA
end

def medical
  tMedical = params[:medical].to_i - params[:medicalbills].to_i
  if tMedical < 0
    tMedical = 0
  end
  tMedical
end

def t80c
  t80c = params[:eightyc].to_i 
  if t80c > 150000
    t80c = 150000
  end
  t80c
end

def t80d
  t80d = params[:eightyd].to_i 
  if t80d > 55000
    t80d = 55000
  end
  t80d
end

def taxable
  params[:basic].to_i + (params[:hra].to_i - eHRA) + medical + params[:others].to_i - t80c - t80d 
end

def tax
  if taxable <= 250000
    tax = 0
  elsif taxable <= 500000
    newTaxable = taxable - 250000
    tax = newTaxable * 0.1
  elsif taxable <= 1000000
    newTaxable = taxable - 500000
    tax = (newTaxable * 0.2) + 25000
  elsif taxable > 1000000
    newTaxable = taxable - 1000000
    tax = (newTaxable * 0.3) + 125000
  end
  tax
end

def cess
  tax*0.02
end

def highcess
  tax*0.01
end

def totalTax
  tax+cess+highcess
end

post '/calculate.json' do
  content_type :json
  { :eHRA => eHRA.round(0), :taxable => taxable.round(0), :tax => tax.round(0), :cess => cess.round(0), :highcess => highcess.round(0), :totaltax => totalTax.round(0) }.to_json
end