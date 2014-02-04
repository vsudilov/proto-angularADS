'use strict';

/* Controllers */

angular.module('myApp.controllers', [])
  
  .controller('ResultsControl', function($scope,$rootScope,$location) {
    this.viewDetail = function(){
      $rootScope.result = $scope.result // Binding this to rootscope is probably really bad!!
      $location.path("/ui/detail/q="+$scope.result.bibcode)
    }
  })

  .controller('DetailControl', function($scope,$rootScope) {
  })
  
  .controller('QueryControl', function($scope,$http,$location,$rootScope) {
    this.submit = function submit () {
      $http.get('/q='+$scope.UserQuery).
        success(function(data, status, headers, config) {
          $rootScope.results = data.results.docs // Binding this to rootscope is probably really bad!!
          $rootScope.facets = data.results.facets.facet_fields
          $location.path("/ui/results/q="+$scope.UserQuery)
        }).
        error(function(data, status, headers, config) {
          console.log('error in ajax request',data,status,headers)
        });
    }
  });