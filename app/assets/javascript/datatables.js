window.addEventListener('DOMContentLoaded', event => {
  // Simple-DataTables
  // https://fiduswriter.github.io/simple-datatables/documentation/
  
  const datatables = document.querySelectorAll('.datatable');
  const expensesTable = document.getElementById('expensesTable');
  const detailedExpensesTable = document.getElementById('detailedExpensesTable');
  
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

  if (detailedExpensesTable) {
    new simpleDatatables.DataTable(detailedExpensesTable, {
      perPage: 20,
      perPageSelect: false,
    });
  }
});
