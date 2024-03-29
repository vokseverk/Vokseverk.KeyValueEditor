﻿function KeyValueEditorController($scope, $timeout) {
	var backspaceHits = 0;

	// Set the visible prompt to -1 to ensure it will not be visible
	$scope.promptIsVisible = "-1";

	$scope.sortableOptions = {
		axis: 'y',
		containment: 'parent',
		cursor: 'move',
		items: '> div.textbox-wrapper',
		tolerance: 'pointer'
	};

	if (!$scope.model.value) {
		$scope.model.value = [];
	}

	// Add any fields that there aren't values for
	if ($scope.model.config.min > 0) {
		for (var i = 0; i < $scope.model.config.min; i++) {
			if ((i + 1) > $scope.model.value.length) {
				$scope.model.value.push({ key: "", value: "" });
			}
		}
	}

	$scope.addRemoveOnKeyDown = function (event, index) {
		var KEY_ESCAPE = 13;
		var KEY_BACKSPACE = 8;

		var txtBoxValue = $scope.model.value[index];
		var txtBoxKey = event.target.name === ("item_" + index + "_key");

		event.preventDefault();

		switch (event.keyCode) {
			case KEY_ESCAPE:
				if ($scope.model.config.max <= 0 && txtBoxValue.value || $scope.model.value.length < $scope.model.config.max && txtBoxValue.value) {
					var newItemIndex = index + 1;
					$scope.model.value.splice(newItemIndex, 0, { key: "", value: "" });

					// Set focus on the newly added value
					$scope.model.value[newItemIndex].hasFocus = true;
				}
				break;

			case KEY_BACKSPACE:
				if ($scope.model.value.length > $scope.model.config.min) {
					var remainder = [];

					// Require an extra hit on backspace for the field to be removed
					if (txtBoxValue.key === "" && txtBoxKey) {
						backspaceHits++;
					} else {
						backspaceHits = 0;
					}

					// Only a BACKSPACE in the empty "Key" field triggers remove
					if (txtBoxKey && txtBoxValue.key === "" && backspaceHits === 2) {
						for (var x = 0; x < $scope.model.value.length; x++) {
							if (x !== index) {
								remainder.push($scope.model.value[x]);
							}
						}

						$scope.model.value = remainder;

						var prevItemIndex = index - 1;

						// Set focus back on false as the directive only watches for true
						if (prevItemIndex >= 0) {
							$scope.model.value[prevItemIndex].hasFocus = false;
							$timeout(function () {
								// Focus on the previous value
								$scope.model.value[prevItemIndex].hasFocus = true;
							});
						}

						backspaceHits = 0;
					}
				}
				break;
			default:
		}
	}

	$scope.add = function () {
		if ($scope.model.config.max <= 0 || $scope.model.value.length < $scope.model.config.max) {
			$scope.model.value.push({ key: "", value: "" });
			// Set focus to the new value
			var newItemIndex = $scope.model.value.length - 1;
			$scope.model.value[newItemIndex].hasFocus = true;
		}
	};

	$scope.remove = function (index) {
		// Make sure not to trigger other prompts when remove is triggered
		$scope.hidePrompt();

		var remainder = [];
		for (var x = 0; x < $scope.model.value.length; x++) {
			if (x !== index) {
				remainder.push($scope.model.value[x]);
			}
		}
		$scope.model.value = remainder;
	};

	$scope.showPrompt = function (idx, item) {

		var i = $scope.model.value.indexOf(item);

		// Make the prompt visible for the clicked tag only
		if (i === idx) {
			$scope.promptIsVisible = i;
		}
	}

	$scope.hidePrompt = function(){
		$scope.promptIsVisible = "-1";
	}
}

angular.module("umbraco").controller("Vokseverk.KeyValueEditorController", KeyValueEditorController);
