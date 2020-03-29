wb = xlsx_package.workbook
col_widths= [10,10,15,15,30,30,30,10]
wb.styles do |style|
  header_1 = style.add_style(sz: 20)
  highlight_cell = style.add_style(bg_color: "EFC376",
                                  border: Axlsx::STYLE_THIN_BORDER,
                                  sz: 13,
                                   alignment: { horizontal: :center })
  border_cell = style.add_style(border: Axlsx::STYLE_THIN_BORDER)       
  wb.add_worksheet(name: "PAYMENT LIST") do |sheet|
    sheet.add_row ["BILL LIST FOR #{@taska.name.upcase}"]
    sheet.add_row [""]
    sheet.add_row ["MONTH",
                  "YEAR",
                  "BILL_ID",
                  "TOTAL(RM)",
                  "NAME",
                  "CLASSROOM",
                  "EXTRA",
                  "PAID"]
    sheet.rows[0].style = header_1
    sheet.rows[2].style = highlight_cell
    counter = 1
    row =2
    @bills.each do |bill|
      bill.kid_bills.each do |kd|
        if kd.extra.present?
          kd.extra.each do |exid|
            extra = Extra.find(exid)
            sheet.add_row [kd.payment.bill_month,
                          kd.payment.bill_year,
                          kd.payment.bill_id,
                          kd.payment.amount,
                          kd.kid.name,
                          kd.kid.classroom.classroom_name,
                          extra.name,
                          kd.payment.paid], style: [nil, border_cell]
            sheet.rows[row+counter].style = border_cell
            counter = counter +1
          end
        elsif !kd.kid.classroom.present?
          sheet.add_row [kd.payment.bill_month,
                          kd.payment.bill_year,
                          kd.payment.bill_id,
                          kd.payment.amount,
                          kd.kid.name,
                          kd.payment.name,
                          "",
                          kd.payment.paid], style: [nil, border_cell]
            sheet.rows[row+counter].style = border_cell
            counter = counter +1
        else
          sheet.add_row [kd.payment.bill_month,
                          kd.payment.bill_year,
                          kd.payment.bill_id,
                          kd.payment.amount,
                          kd.kid.name,
                          kd.kid.classroom.classroom_name,
                          "",
                          kd.payment.paid], style: [nil, border_cell]
            sheet.rows[row+counter].style = border_cell
            counter = counter +1
        end
      end
      sheet.column_widths *col_widths
    end
  end
end

















