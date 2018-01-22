/**
 * Created by yves.godart on 29/03/2017.
 */

var CSCBackupDash = angular.module("CSCBackupDash", ["ngRoute","ui.bootstrap","angularUtils.directives.dirPagination","ngAnimate","ngSanitize"]);

CSCBackupDash.service('Params', [function()
{
   var APB = "";

    return {
       getAPB: function(){
           return APB;
       },
        setAPB: function(apb)
        {
            APB = apb;
        }
    };

}]);

CSCBackupDash.config(function ($routeProvider,$locationProvider) {
    $locationProvider.hashPrefix('');
    $routeProvider
        .when(
            "/",
            {
                templateUrl: "pharmas.html",
                controller: "PharmaController"
            }
        )
        .when(
          "/backups/master",
            {
                templateUrl: "master.html",
                controller: "MasterController"
            }
        )
        .when(
            "/backups/detail/:Id",
            {
                templateUrl: "detail.html",
                controller: "DetailController"
            }
        )
        .when(
            "/updates/master",
            {
                templateUrl: "upg_master.html",
                controller: "UpgMasterController"
            }
        )
        .when(
            "/updates/detail/:id",
            {
               templateUrl: "upg_detail.html",
                controller: "UpgDetailController"
            }
        ).when(
           "/pharma",
        {
            templateUrl: "pharmas.html",
            controller: "PharmaController"
        }

    );
});

CSCBackupDash.controller("DetailController", function($scope,$http,$routeParams)
{

    $scope.Id = $routeParams.Id;
    $http({
        method: 'GET',
        url: 'select_backups.php?func=detail&id='+$scope.Id
    }).then(function (response) {
        $scope.details = response.data;
        console.log("success");
        //console.log(response);
    }, function (response) {
        console.log("fail");
        console.log(response);
    });

    $scope.lineState = function (state) {
        if (state == 0)
            return "Success"
        else
            return "Fail";
    };
});


CSCBackupDash.controller("MasterController", function ($scope, $http, $location,Params) {
    $scope.bigData = {};

    $scope.bigData.breakfast = false;
    $scope.bigData.lunch = false;
    $scope.bigData.dinner = false;

    $scope.redirect = function(url){
      $location.path(url);

    };

    // COLLAPSE =====================
    $scope.isCollapsed = false;
    //$http({
    //    method: 'GET',
    //    url: 'select_backups.php?func=header&apb='+Params.getAPB()
    $http.get('select_backups.php',
        { params: {func: 'header', apb: Params.getAPB()}
    }).then(function (response) {
        $scope.backups = response.data;
        console.log("success");
        //console.log(response);
    }, function (response) {
        console.log("fail");
        console.log(response);
    });

    $scope.sort = function(keyname){
        $scope.sortkey = keyname;
        $scope.reverse = !$scope.reverse;
    };

    $scope.backupState = function (state) {
        if (state == 0)
            return "Success"
        else
            return "Fail";
    };

    $scope.redirect = function (url){
        $location.path(url);
    };

    /**
     * Created by yves.godart on 10/04/2017.
     */
    $scope.sendJSON =  function (){
        alert("Send JSON");
        var myObj = {
            date_time: "10\/04\/2017",
            apb: "999999",
            updversion: "1.0.0.5",
            cscversion_before: "1.1.0.57",
            cscversion_after: "1.1.0.57",
            result: 0,
            Log: [{
                Timestamp: "18:53:37",
                Description: "TempPath : C:\\Users\\yves.godart\\AppData\\Local\\Temp\\Corilus_BackupXE\\"
            }, {
                Timestamp: "18:53:37",
                Description: "UndoPath : C:\\Users\\yves.godart\\AppData\\Local\\Temp\\Corilus_BackupXE\\Undo\\"
            }, {
                Timestamp: "18:53:39",
                Description: "Undo file generated at [C:\\Users\\yves.godart\\AppData\\Local\\Temp\\Corilus_BackupXE\\Undo\\Old.zip]"
            }, {
                Timestamp: "18:53:41",
                Description: "Process OPSWBACKUP.EXE is not running"
            }, {
                Timestamp: "18:53:41",
                Description: "Process CSCBACKUPXE.EXE is not running"
            }, {
                Timestamp: "18:53:41",
                Description: "Extracting [C:\\Users\\yves.godart\\AppData\\Local\\Temp\\Corilus_BackupXE\\CSCXE.zip]"
            }, {
                Timestamp: "18:53:41",
                Description: "Decompression"
            }, {
                Timestamp: "18:53:41",
                Description: "Zip content : "
            }, {
                Timestamp: "18:53:41",
                Description: "  - ChangeLog.txt [1014] -> [2298] CRC : 1777938583"
            }, {
                Timestamp: "18:53:41",
                Description: "  - CSCBackupXE.exe [3654996] -> [7082496] CRC : 1928385867"
            }, {
                Timestamp: "18:53:41",
                Description: "Deleting Zip file"
            }, {
                Timestamp: "18:53:41",
                Description: "C:\\Users\\yves.godart\\AppData\\Local\\Temp\\Corilus_BackupXE\\ChangeLog.txt ==> C:\\corilus_backup\\ChangeLog.txt"
            }, {
                Timestamp: "18:53:41",
                Description: "C:\\Users\\yves.godart\\AppData\\Local\\Temp\\Corilus_BackupXE\\CSCBackupXE.exe ==> C:\\corilus_backup\\CSCBackupXE.exe"
            }, {
                Timestamp: "18:53:41",
                Description: "C:\\Users\\yves.godart\\AppData\\Local\\Temp\\Corilus_BackupXE\\Undo ==> C:\\corilus_backup\\Undo"
            }, {
                Timestamp: "18:53:42",
                Description: "** Update successefully terminated **"
            }]
        };

        var myLog = {
            APB: "999999",
            GO_VERSION: "1.0.60",
            GO_PATCH: "P23",
            CSC_VERSION: "1.1.0.38",
            DT_START: "20\/03\/2017 10:11:09",
            DT_STOP: "20\/03\/2017 10:11:23",
            result: 0,
            Log: [
                {
                    Timestamp: "10:11:07.808",
                    Type_Ligne: 1,
                    Description: "C:\\Develop\\CSCBackupXE\\Win32\\Debug\\ "
                },
                {
                    Timestamp: "10:11:09.702",
                    Type_Ligne: 1,
                    Description: "Greenock Backup [1.0.60, P23]"
                },
                {
                    Timestamp: "10:11:09.702",
                    Type_Ligne: 1,
                    Description: "CSCBackupXE  (1.1.0.38)"
                },
                {
                    Timestamp: "10:11:09.702",
                    Type_Ligne: 1,
                    Description: "Start"
                },
                {
                    Timestamp: "10:11:09.702",
                    Type_Ligne: 1,
                    Description: "Using Temp Dir : C:\\Develop\\CSCBackupXE\\Win32\\Debug\\Temp\\"
                },
                {
                    Timestamp: "10:11:09.702",
                    Type_Ligne: 1,
                    Description: "C:\\Develop\\CSCBackupXE\\Win32\\Debug\\Temp\\20170320101109_1.0.60P23_999999.zip"
                },
                {
                    Timestamp: "10:11:16.651",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Data\/CPCL.mdf  "
                },
                {
                    Timestamp: "10:11:16.717",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Data\/Delphicare.mdf  "
                },
                {
                    Timestamp: "10:11:16.720",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Data\/Greenock.mdf  "
                },
                {
                    Timestamp: "10:11:16.722",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Data\/GreenockINN.mdf  "
                },
                {
                    Timestamp: "10:11:16.726",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Data\/GreenockSvcLogging.mdf  "
                },
                {
                    Timestamp: "10:11:16.729",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Log\/CPCL_log.ldf  "
                },
                {
                    Timestamp: "10:11:16.733",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Log\/Delphicare_log.ldf  "
                },
                {
                    Timestamp: "10:11:16.736",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Log\/GreenockINN_log.ldf  "
                },
                {
                    Timestamp: "10:11:16.739",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Log\/GreenockSvcLogging_log.ldf  "
                },
                {
                    Timestamp: "10:11:16.744",
                    Type_Ligne: 2,
                    Description: " **Error** ProgramData\/Corilus\/Common\/Data\/SQLServer\/Log\/Greenock_log.ldf  "
                },
                {
                    Timestamp: "10:11:16.971",
                    Type_Ligne: 1,
                    Description: "ProgramData\/Corilus\/Common\/Data\/SQLServer\/backup\/GreenockMaintenanceDB_APB.log 0 bytes => 0 bytes"
                },
                {
                    Timestamp: "10:11:16.971",
                    Type_Ligne: 1,
                    Description: "ProgramData\/Corilus\/Common\/Data\/SQLServer\/backup\/GreenockUpdateBackupTask.log 714 bytes => 279 bytes"
                },
                {
                    Timestamp: "10:11:16.976",
                    Type_Ligne: 1,
                    Description: "Applying rotation (Nb max : 0 Days Max : 0)"
                },
                {
                    Timestamp: "10:11:16.978",
                    Type_Ligne: 1,
                    Description: "Stop"
                },
                {
                    Timestamp: "10:11:16.978",
                    Type_Ligne: 1,
                    Description: "Warnings : 0   Errors : 10"
                },
                {
                    Timestamp: "10:11:16.978",
                    Type_Ligne: 1,
                    Description: "Elapsed : 00:00:07"
                },
                {
                    Timestamp: "10:11:16.978",
                    Type_Ligne: 1,
                    Description: "Uncomp Size : 714 bytes"
                },
                {
                    Timestamp: "10:11:16.978",
                    Type_Ligne: 1,
                    Description: "Comp Size : 279 bytes"
                },
                {
                    Timestamp: "10:11:16.978",
                    Type_Ligne: 1,
                    Description: "Target Size : 499581448192  Target Free : 216747630592"
                },
                {
                    Timestamp: "10:11:16.978",
                    Type_Ligne: 1,
                    Description: "Temp Size : 499581448192  Temp Free : 216747630592"
                }
            ]};

        var xhr = new XMLHttpRequest();
        //var url = "http://backup.sherpagreenock.be/SaveLog.php?func=test";
        var url = "http://localhost:8080/dash/index_10.php";

        xhr.open("POST",url,true);
        xhr.setRequestHeader("Content-Type","application/json");
        xhr.onreadystatechange = function(){
            if (xhr.readyState == 4 && xhr.status ==200) {
                console.log(xhr.responseText);
                var json = JSON.parse(xhr.responseText);
                //console.log(json.received);
                //$("#envoyer").text("Ok : "+json.received);
            }
            else
            {
                //$("#envoyer").text("Error : "+xhr.status);
            }
        }
        var data = JSON.stringify(myObj);
        xhr.send(data);
    }


});

CSCBackupDash.controller("UpgMasterController", function ($scope, $http, $location,Params) {
    var $ctrl = this;

    $scope.bigData = {};

    $scope.bigData.breakfast = false;
    $scope.bigData.lunch = false;
    $scope.bigData.dinner = false;

    $scope.redirect = function(url){
        $location.path(url);

    };

    // COLLAPSE =====================
    $scope.isCollapsed = false;
    $http({
        method: 'GET',
        url: 'select_updates.php?func=header'
    }).then(function (response) {
        $scope.sessions = response.data;
        console.log("success");
        //console.log(response);
    }, function (response) {
        console.log("fail");
        console.log(response);
    });

    $scope.sort = function(keyname){
        $scope.sortkey = keyname;
        $scope.reverse = !$scope.reverse;
    };

    $scope.sessionstate = function (state) {
        if (state == 0)
            return "Success"
        else
            return "Fail";
    };
});


CSCBackupDash.controller("UpgDetailController", function($scope,$http,$routeParams,Params)
{

    $scope.id = $routeParams.id;
    $http({
        method: 'GET',
        url: 'select_updates.php?func=detail&id='+$scope.id
    }).then(function (response) {
        $scope.logs = response.data;
        console.log("success");
        //console.log(response);
    }, function (response) {
        console.log("fail");
        console.log(response);
    });

    $scope.lineState = function (state) {
        if (state == 0)
            return "Success"
        else
            return "Fail";
    };
});

CSCBackupDash.controller("PharmaController",function($scope,$http,$routeParams,$location,$uibModal,$document,$log,Params) {
    var $ctrl = this;
    $ctrl.animationsEnabled = true;

    $ctrl.open = function(Apb, size, parentSelector)
    {
        $scope.apb = Apb;
        var parentElem = parentSelector ?
            angular.element($document[0].querySelector('.modal-result ' + parentSelector)) : undefined;
        var modalInstance = $uibModal.open({
            animation: $ctrl.animationsEnabled,
            ariaLabelledBy: 'modal-title',
            ariaDescribedBy: 'modal-body',
            templateUrl: 'modalresult.html',
            controller: 'modalresultCtrl',
            controllerAs: '$ctrl',
            size: size,
            appendTo: parentElem,
            resolve: {
                apb: function()
                {
                    return Apb;
                }
            }
        });

        modalInstance.result.then(function (selectedItem) {
            $ctrl.selected = selectedItem;
            console.log(Apb+" : "+$ctrl.selected);
        }, function () {
            $log.info('Modal dismissed at: ' + new Date());
        });
    };

    $http({
        method: 'GET',
        url: 'select_backups.php?func=pharmas'

    }).then(function (response) {
        $scope.pharmas = response.data;
        //console.log("success");
        //console.log(response.data);
    }, function (response) {
        //console.log("fail");
        //console.log(response);

    });

    $scope.initAPB = function()
    {
        Params.setAPB("");
        location.reload();
    }

    $scope.clickAPB = function(apb){
        Params.setAPB(apb);
        $location.path('/backups/master');
    }


});

angular.module('CSCBackupDash').controller('modalresultCtrl', function ($uibModalInstance,$scope,apb) {
    var $ctrl = this;
    $scope.apb = apb;

    $ctrl.ok = function () {
        $uibModalInstance.close(1);
    };

    $ctrl.cancel = function () {
        $uibModalInstance.dismiss('cancel');
    };
});


