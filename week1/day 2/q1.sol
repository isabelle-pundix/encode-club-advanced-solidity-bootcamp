/*
 * Write a function that will delete items (one at a time) from a dynamic array without leaving gaps in the array.
 * You should assume that the items to be deleted are chosen at random, and try to do this in a gas efficient manner.
 * For example imagine your array has 12 items and you need to delete the items at indexes 8, 2 and 7.
 * The final array will then have items {0,1,3,4,5,6,9,10,11}
 */

function deleteArray(
    uint256[] storage array,
    uint256[] storage indexesToDelete
) {
    for (uint256 i; i < indexesToDelete.length; i++) {
        uint256 indexToDelete = indexesToDelete[i];

        array[indexToDelete] = array[array.length - 1];

        array.pop();
    }
}
