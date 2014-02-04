'use strict';


// Declare app level module which depends on filters, and services
angular.module('myApp', [
  'ngRoute',
  'myApp.filters',
  'myApp.services',
  'myApp.directives',
  'myApp.controllers'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/ui/results/q=:UserQuery', {templateUrl: '/static/partials/results.html', controller: 'ResultsControl'});
  $routeProvider.when('/ui/detail/q=:bibcode', {templateUrl: '/static/partials/detail.html',controller: 'DetailControl'});
  //$routeProvider.otherwise({redirectTo: '/query'});
}]);
