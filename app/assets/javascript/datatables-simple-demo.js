window.addEventListener('DOMContentLoaded', event => {
  // Simple-DataTables
  // https://github.com/fiduswriter/Simple-DataTables/wiki
  
  const datatables = document.querySelectorAll('.datatable');
  const expensesTable = document.getElementById('expensesTable');
  
  if (datatables) {
    datatables.forEach(
      function (datatable) {
        new simpleDatatables.DataTable(datatable, {
          searchable: false,
          perPage: 3,
          perPageSelect: false,
        });
      }
    )
  }

  if (expensesTable) {
    new simpleDatatables.DataTable(expensesTable, {
      searchable: false,
      perPage: 10,
      perPageSelect: false,
    });
  }
});
