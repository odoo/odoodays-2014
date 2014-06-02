{
    'name': 'My Theme',
    'category': 'Website',
    'summary': 'Customisations',
    'version': '1.0',
    'description': """
Feuerwear Customisations
======================================
        """,
    'author': 'fp@odoo.com',
    'depends': ['website'],
    'data': ['data/my_theme.xml',
             'data/snippets.xml',
             'data/options.xml',
             'data/pages.xml',
    ],
    'installable': True,
}
