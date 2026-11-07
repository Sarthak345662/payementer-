<?php

return [
    'name' => 'Vizion',
    'author' => 'Your Name',
    'url' => 'https://github.com/your-username/vizion',

    'config' => [
        [
            'name' => 'primary_color',
            'label' => 'Primary Color',
            'type' => 'color',
            'default' => '#3b82f6',
            'description' => 'Accent color used for active menu items, buttons and charts.',
            'required' => true,
        ],
        [
            'name' => 'custom_css',
            'label' => 'Custom CSS',
            'type' => 'textarea',
            'default' => '',
            'description' => 'Extra CSS to override the Vizion styles.',
            'required' => false,
        ],
    ],
];
