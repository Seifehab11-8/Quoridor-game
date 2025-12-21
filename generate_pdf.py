#!/usr/bin/env python3
"""
Generate PDF documentation from Dart API HTML output using WeasyPrint
Extracts content from Dart docs and creates a simplified HTML for PDF conversion
"""

from weasyprint import HTML, CSS
from bs4 import BeautifulSoup
import os
from pathlib import Path
import re

def extract_library_info(html_file):
    """Extract library information from a Dart doc HTML file"""
    with open(html_file, 'r', encoding='utf-8') as f:
        soup = BeautifulSoup(f.read(), 'html.parser')
    
    info = {
        'title': '',
        'description': '',
        'classes': [],
        'functions': [],
        'constants': []
    }
    
    # Get title
    title_elem = soup.find('h1')
    if title_elem:
        info['title'] = title_elem.get_text(strip=True)
    
    # Get description
    desc_elem = soup.find('section', class_='desc')
    if desc_elem:
        info['description'] = desc_elem.get_text(strip=True)
    
    return info

# Path to Dart doc HTML index
doc_dir = Path('doc/api')
output_pdf = Path('Quoridor_Dart_Documentation.pdf')

print(f"Generating PDF from Dart documentation...")
print(f"Input directory: {doc_dir}")
print(f"Output: {output_pdf}")

try:
    # Find all library HTML files
    library_files = sorted([
        f for f in doc_dir.glob('**/index.html')
        if 'quoridor_game' in str(f) or f.parent.name in [
            'game_logic_player', 'game_logic_human_player', 'game_logic_computer_player',
            'helper_game_state', 'helper_helper_func', 'helper_move_data',
            'views_pages_board', 'views_pages_pawn', 'views_pages_square',
            'views_pages_wall', 'views_pages_scoreboard_walls',
            'views_screens_game_screen', 'views_screens_start_screen',
            'main'
        ]
    ])
    
    print(f"Found {len(library_files)} documentation files")
    
    # Create simplified HTML content
    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Quoridor Game - Dart API Documentation</title>
    </head>
    <body>
        <h1>Quoridor Game - Dart API Documentation</h1>
        <p><strong>Generated from dartdoc</strong></p>
        <p>Date: December 21, 2025</p>
        <hr>
        
        <h2>Table of Contents</h2>
        <ul>
    """
    
    # Build table of contents
    toc_items = []
    for lib_file in library_files:
        lib_name = lib_file.parent.name
        if lib_name != 'api':
            friendly_name = lib_name.replace('_', ' > ').title()
            toc_items.append(f'<li><a href="#{lib_name}">{friendly_name}</a></li>')
    
    html_content += '\n'.join(toc_items)
    html_content += """
        </ul>
        <hr>
    """
    
    # Extract content from each library
    for lib_file in library_files:
        lib_name = lib_file.parent.name
        if lib_name == 'api':
            continue
            
        try:
            with open(lib_file, 'r', encoding='utf-8') as f:
                soup = BeautifulSoup(f.read(), 'html.parser')
            
            friendly_name = lib_name.replace('_', ' > ').title()
            html_content += f'\n<h2 id="{lib_name}">{friendly_name}</h2>\n'
            
            # Extract main description
            desc = soup.find('section', class_='desc')
            if desc:
                # Clean up the description text
                desc_text = desc.get_text(separator=' ', strip=True)
                html_content += f'<p>{desc_text}</p>\n'
            
            # Extract ALL sections with more detail
            sections_to_extract = [
                ('classes', 'Classes'),
                ('enums', 'Enums'),
                ('mixins', 'Mixins'),
                ('extensions', 'Extensions'),
                ('constants', 'Constants'),
                ('properties', 'Properties'),
                ('functions', 'Functions'),
                ('typedefs', 'Typedefs'),
            ]
            
            for section_id, section_title in sections_to_extract:
                section = soup.find('section', class_='summary', attrs={'id': section_id})
                if section:
                    html_content += f'<h3>{section_title}</h3>\n<dl>\n'
                    
                    # Extract all dt/dd pairs
                    for dt in section.find_all('dt'):
                        # Get the full signature/name
                        name_elem = dt.find('span', class_='name') or dt
                        item_name = name_elem.get_text(separator=' ', strip=True)
                        
                        # Get description
                        dd = dt.find_next_sibling('dd')
                        item_desc = dd.get_text(separator=' ', strip=True) if dd else ''
                        
                        html_content += f'<dt><code>{item_name}</code></dt>\n'
                        html_content += f'<dd>{item_desc}</dd>\n'
                    
                    html_content += '</dl>\n'
            
            # Now extract detailed class information from individual class pages
            class_links = soup.select('a[href*="-class.html"]')
            for link in class_links:
                class_href = link.get('href')
                if class_href:
                    class_file = lib_file.parent / class_href
                    if class_file.exists():
                        try:
                            with open(class_file, 'r', encoding='utf-8') as cf:
                                class_soup = BeautifulSoup(cf.read(), 'html.parser')
                            
                            class_title = class_soup.find('h1')
                            if class_title:
                                html_content += f'\n<h3>Class: {class_title.get_text(separator=" ", strip=True)}</h3>\n'
                            
                            # Get class description
                            class_desc = class_soup.find('section', class_='desc')
                            if class_desc:
                                html_content += f'<p><em>{class_desc.get_text(separator=" ", strip=True)}</em></p>\n'
                            
                            # Extract constructors
                            constructors = class_soup.find('section', attrs={'id': 'constructors'})
                            if constructors:
                                html_content += '<h4>Constructors</h4>\n<dl>\n'
                                for dt in constructors.find_all('dt'):
                                    name = dt.get_text(separator=' ', strip=True)
                                    dd = dt.find_next_sibling('dd')
                                    desc = dd.get_text(separator=' ', strip=True) if dd else ''
                                    html_content += f'<dt><code>{name}</code></dt><dd>{desc}</dd>\n'
                                html_content += '</dl>\n'
                            
                            # Extract instance properties
                            properties = class_soup.find('section', attrs={'id': 'instance-properties'})
                            if properties:
                                html_content += '<h4>Properties</h4>\n<dl>\n'
                                for dt in properties.find_all('dt'):
                                    name = dt.get_text(separator=' ', strip=True)
                                    dd = dt.find_next_sibling('dd')
                                    desc = dd.get_text(separator=' ', strip=True) if dd else ''
                                    html_content += f'<dt><code>{name}</code></dt><dd>{desc}</dd>\n'
                                html_content += '</dl>\n'
                            
                            # Extract instance methods
                            methods = class_soup.find('section', attrs={'id': 'instance-methods'})
                            if methods:
                                html_content += '<h4>Methods</h4>\n<dl>\n'
                                for dt in methods.find_all('dt'):
                                    name = dt.get_text(separator=' ', strip=True)
                                    dd = dt.find_next_sibling('dd')
                                    desc = dd.get_text(separator=' ', strip=True) if dd else ''
                                    html_content += f'<dt><code>{name}</code></dt><dd>{desc}</dd>\n'
                                html_content += '</dl>\n'
                            
                            # Extract static methods
                            static_methods = class_soup.find('section', attrs={'id': 'static-methods'})
                            if static_methods:
                                html_content += '<h4>Static Methods</h4>\n<dl>\n'
                                for dt in static_methods.find_all('dt'):
                                    name = dt.get_text(separator=' ', strip=True)
                                    dd = dt.find_next_sibling('dd')
                                    desc = dd.get_text(separator=' ', strip=True) if dd else ''
                                    html_content += f'<dt><code>{name}</code></dt><dd>{desc}</dd>\n'
                                html_content += '</dl>\n'
                                
                        except Exception as e:
                            print(f"Warning: Could not process class file {class_file}: {e}")
            
            html_content += '<hr>\n'
            
        except Exception as e:
            print(f"Warning: Could not process {lib_file}: {e}")
            continue
    
    html_content += """
    </body>
    </html>
    """
    
    # Create PDF with custom styling
    css = CSS(string='''
        @page {
            size: A4;
            margin: 2cm 2.5cm;
        }
        * {
            box-sizing: border-box;
        }
        body {
            font-family: Georgia, serif;
            font-size: 9pt;
            line-height: 1.5;
            color: #333;
            max-width: 100%;
            overflow-x: hidden;
        }
        h1 {
            color: #0066cc;
            border-bottom: 3px solid #0066cc;
            padding-bottom: 10px;
            font-size: 18pt;
        }
        h2 {
            color: #0088dd;
            border-bottom: 2px solid #ddd;
            padding-bottom: 5px;
            margin-top: 30px;
            font-size: 14pt;
            page-break-before: always;
        }
        h3 {
            color: #666;
            margin-top: 20px;
            font-size: 12pt;
        }
        h4 {
            color: #888;
            margin-top: 15px;
            font-size: 10pt;
        }
        code {
            font-family: "Courier New", monospace;
            font-size: 7.5pt;
            background: #f5f5f5;
            padding: 3px 5px;
            border-radius: 2px;
            word-break: break-word;
            overflow-wrap: break-word;
            hyphens: none;
        }
        ul {
            margin-left: 20px;
        }
        li {
            margin-bottom: 8px;
        }
        dl {
            margin-left: 10px;
            margin-right: 10px;
            max-width: 100%;
        }
        dt {
            font-weight: bold;
            margin-top: 12px;
            color: #444;
            page-break-inside: avoid;
            page-break-after: avoid;
            max-width: 100%;
        }
        dt code {
            display: block;
            padding: 8px;
            background: #f8f8f8;
            border-left: 3px solid #0066cc;
            margin: 5px 0;
            word-break: break-word;
            overflow-wrap: break-word;
            white-space: normal;
            max-width: 100%;
            line-height: 1.6;
            hyphens: none;
        }
        dd {
            margin-left: 20px;
            margin-bottom: 15px;
            margin-top: 5px;
            word-wrap: break-word;
            overflow-wrap: break-word;
            page-break-inside: avoid;
            max-width: 100%;
        }
        hr {
            border: none;
            border-top: 1px solid #ddd;
            margin: 25px 0;
            page-break-after: avoid;
        }
        a {
            color: #0066cc;
            text-decoration: none;
            word-wrap: break-word;
        }
        p {
            margin: 10px 0;
            text-align: justify;
            max-width: 100%;
        }
    ''')
    
    HTML(string=html_content).write_pdf(output_pdf, stylesheets=[css])
    
    print(f"\n✅ Success! PDF generated at: {output_pdf}")
    print(f"   File size: {output_pdf.stat().st_size / 1024:.2f} KB")
    print(f"\n📄 Open with: open {output_pdf}")
    
except Exception as e:
    print(f"\n❌ Error: {e}")
    import traceback
    traceback.print_exc()
