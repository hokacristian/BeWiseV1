import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final Function(int) onPageChanged;
  final Color backgroundColor;
  final Color activeColor;
  final Color textColor;

  const PaginationWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.onPageChanged,
    this.backgroundColor = Colors.white,
    this.activeColor = const Color(0xFF2B59C3), // Warna yang diminta
    this.textColor = Colors.black,
  }) : super(key: key);

  Widget _buildPageButton(int page, int currentPage) {
    bool isSelected = page == currentPage;
    
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? activeColor : Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ] : null,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: isSelected ? Colors.white : textColor,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          minimumSize: const Size(32, 32),
        ),
        onPressed: () => onPageChanged(page),
        child: Text(
          '$page',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: const Text(
        '...',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPrevNextButton(bool isPrev) {
    final bool isEnabled = isPrev ? hasPreviousPage : hasNextPage;
    
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          isPrev ? Icons.chevron_left : Icons.chevron_right,
          size: 18,
          color: isEnabled ? textColor : Colors.grey.shade400,
        ),
        onPressed: isEnabled
            ? () => onPageChanged(isPrev ? currentPage - 1 : currentPage + 1)
            : null,
      ),
    );
  }

  List<Widget> _buildPageNumbers(int currentPage, int totalPages) {
    List<Widget> pageNumbers = [];
    
    // Previous button
    pageNumbers.add(_buildPrevNextButton(true));
    
    // Always show page 1
    if (currentPage > 3) {
      pageNumbers.add(_buildPageButton(1, currentPage));
      pageNumbers.add(_buildEllipsis());
    }
    
    // Calculate range of pages to show
    int startPage = (currentPage > 2) ? currentPage - 1 : 1;
    int endPage = (currentPage < totalPages - 1) ? currentPage + 1 : totalPages;
    
    // Make sure we don't go out of bounds
    startPage = startPage < 1 ? 1 : startPage;
    endPage = endPage > totalPages ? totalPages : endPage;
    
    // Add page buttons
    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(_buildPageButton(i, currentPage));
    }
    
    // Show ellipsis and last page if needed
    if (currentPage < totalPages - 2) {
      pageNumbers.add(_buildEllipsis());
      pageNumbers.add(_buildPageButton(totalPages, currentPage));
    }
    
    // Next button
    pageNumbers.add(_buildPrevNextButton(false));
    
    return pageNumbers;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageNumbers(currentPage, totalPages),
          ),
        ),
      ),
    );
  }
}