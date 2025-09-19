import pandas as pd

# Ruta al archivo Excel
file_path = "20240914 - Data.xlsx"

# Cargar todas las hojas
excel_file = pd.ExcelFile(file_path)

# Archivo de salida
output_file = "tutoring-school-DML.sql"

with open(output_file, "w", encoding="utf-8") as f:
    for sheet in excel_file.sheet_names:
        df = pd.read_excel(file_path, sheet_name=sheet)

        # Normalizar nombre de tabla (sin espacios)
        table_name = sheet.replace(" ", "_")

        # Nombres de columnas (con _ en lugar de espacios)
        cols = ", ".join([str(c).replace(" ", "_") for c in df.columns])

        values_list = []
        for _, row in df.iterrows():
            vals = []
            for v in row:
                if pd.isna(v):
                    vals.append("NULL")
                elif isinstance(v, (int, float)):
                    vals.append(str(v))
                else:
                    vals.append(f"'{str(v).replace("'", "''")}'")
            values_list.append("(" + ", ".join(vals) + ")")

        if values_list:  # Solo si hay datos
            insert_stmt = f"INSERT INTO {table_name} ({cols}) VALUES\n" + ",\n".join(values_list) + ";\n\n"
            f.write(insert_stmt)

print(f"✅ Script generado: {output_file}")
