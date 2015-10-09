public class Util_Sorter {

    private String column;
    public String sortDirection;
    private String column2;
    public String sortDirection2;
    public final static String SORT_ASC = 'ASC';
    public final static String SORT_DESC = 'DESC';
    
    public Util_Sorter(String defaultSortColumn, String defaultSortDirection, String defaultSortColumn2, String defaultSortDirection2){
        this.column = defaultSortColumn;
        this.sortDirection = defaultSortDirection;
        this.column2 = defaultSortColumn2;
        this.sortDirection2 = defaultSortDirection2;
    }
    
    public String getSortDirection() {
        return this.sortDirection;
    }
    
    public String getSortDirection2() {
        return this.sortDirection2;
    }
    
    public String getColumn() {
        return this.column;
    }
    
    public String getColumn2() {
        return this.column2;
    }
    
    public void setColumn(String ColumnName){
        if(column.equalsIgnoreCase(columnName)) {
            sortDirection = (sortDirection.equals(SORT_ASC)) ? SORT_DESC : SORT_ASC;
        } else {
            this.sortDirection2 = this.sortDirection;
            this.column2 = this.column;
            this.sortDirection = SORT_ASC;
            this.column = columnName;
        }
    }
    
}